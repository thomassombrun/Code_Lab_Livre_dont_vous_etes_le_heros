extends Control

@onready var statut = $VBoxContainer/Statut
@onready var texte = $VBoxContainer/Texte
@onready var boite_choix = $VBoxContainer/Choix

# L'HISTOIRE : uniquement des données, aucune logique
var histoire = {
	"debut": {
		"texte": "Tu te réveilles dans une forêt sombre. Un sentier part vers le nord, une rivière coule à l'est.",
		"choix": [
			{"libelle": "Suivre le sentier", "suite": "sentier"},
			{"libelle": "Aller vers la rivière", "suite": "riviere"},
			{"libelle": "Grimper à un arbre", "suite": "arbre"},
		],
	},
	"sentier": {
		"texte": "Le sentier mène à une cabane fermée à clé.",
		"choix": [
			{"libelle": "Ouvrir la porte avec la clé", "suite": "cabane", "condition": "cle"},
			{"libelle": "Revenir en arrière", "suite": "debut"},
		],
	},
	"riviere": {
		"texte": "L'eau glacée te coupe le souffle. Au bord, une clé rouillée brille.",
		"pv": -3,
		"objet": "cle",
		"choix": [
			{"libelle": "Revenir au début", "suite": "debut"},
		],
	},
	"arbre": {
		"texte": "Il y as beaucoup de branche.",
		"choix": [
			{"libelle": "Casser des branches", "suite": "chateau"},
			{"libelle": "Redescendre de l'arbre", "suite": "debut"},
		],
	},
	"cabane": {
		"texte": "Une vieille dame t'accueille au chaud. FIN (bonne)",
		"choix": [],
	},
	"noyade": {
		"texte": "Le courant t'emporte... FIN (mauvaise)",
		"choix": [],
	},
	"chateau": {
		"texte": "Un immense château se profile a l'horizon. FIN (a suivre)",
		"choix": [],
	}	
}
const DEPART = "debut"
const PV_MAX = 10

var passage = DEPART
var pv = PV_MAX
var inventaire = []

func _ready():
	nouvelle_partie()

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
		pv += p["pv"]
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
		return

	if p["choix"].is_empty():
		ajouter_bouton("Rejouer", nouvelle_partie)
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
	
