extends Control

@onready var statut = $VBoxContainer/Statut
@onready var texte = $VBoxContainer/Texte
@onready var boite_choix = $VBoxContainer/Choix

const THEMES = {
	"Médiéval": "res://histoire_medieval.json",
	"Cyberpunk": "res://histoire_cyberpunk.json",
	"Horreur": "res://histoire_horreur.json",
}

const DEPART = "debut"
const PV_MAX = 10

var histoire = {}
var passage = DEPART
var pv = PV_MAX
var inventaire = []

func _ready():
	afficher_menu()

func afficher_menu():
	statut.text = ""
	texte.text = "Choisis ton aventure :"
	for bouton in boite_choix.get_children():
		bouton.queue_free()
	for nom in THEMES:
		ajouter_bouton(nom, lancer_theme.bind(THEMES[nom]))

func lancer_theme(chemin):
	histoire = charger_histoire(chemin)
	if histoire.is_empty():
		texte.text = "Erreur : impossible de charger " + chemin
		return
	verifier_histoire()
	nouvelle_partie()

func charger_histoire(chemin):
	var fichier = FileAccess.open(chemin, FileAccess.READ)
	if fichier == null:
		push_error("Fichier introuvable : " + chemin)
		return {}
	var donnees = JSON.parse_string(fichier.get_as_text())
	if donnees == null:
		push_error("JSON invalide dans " + chemin)
		return {}
	return donnees

func verifier_histoire():
	if not histoire.has(DEPART):
		push_error("Passage de départ manquant : " + DEPART)
	for id in histoire:
		for c in histoire[id]["choix"]:
			if not histoire.has(c["suite"]):
				push_error("Lien cassé : '" + id + "' mène à '" + c["suite"] + "' qui n'existe pas")

func nouvelle_partie():
	pv = PV_MAX
	inventaire = []
	aller_a(DEPART)

func aller_a(suite):
	passage = suite
	appliquer_effets(histoire[passage])
	afficher()

func appliquer_effets(p):
	if p.has("pv"):
		pv += int(p["pv"])
	if p.has("objet") and not inventaire.has(p["objet"]):
		inventaire.append(p["objet"])
	
func afficher():
	var p = histoire[passage]
	statut.text = "PV : " + str(pv) + " / " + str(PV_MAX) + "   Inventaire : " + str(inventaire)
	texte.text = p["texte"]
	for bouton in boite_choix.get_children():
		bouton.queue_free()

	if pv <= 0:
		texte.text += "\n\nTu n'as plus de forces... FIN (mauvaise)"
		ajouter_bouton("Rejouer", nouvelle_partie)
		ajouter_bouton("Changer de thème", afficher_menu)
		return

	if p["choix"].is_empty():
		ajouter_bouton("Rejouer", nouvelle_partie)
		ajouter_bouton("Changer de thème", afficher_menu)
		return

	for c in p["choix"]:
		if c.has("condition") and not inventaire.has(c["condition"]):
			continue
		ajouter_bouton(c["libelle"], aller_a.bind(c["suite"]))
	
func ajouter_bouton(libelle, action):
	var bouton = Button.new()
	bouton.text = libelle
	bouton.pressed.connect(action)
	boite_choix.add_child(bouton)
	
