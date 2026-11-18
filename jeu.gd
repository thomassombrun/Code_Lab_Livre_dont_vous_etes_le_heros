extends Control

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
		"texte": "Le sentier mène à une cabane éclairée.",
		"choix": [
			{"libelle": "Frapper à la porte", "suite": "cabane"},
			{"libelle": "Revenir en arrière", "suite": "debut"},
		],
	},
	"riviere": {
		"texte": "L'eau est glacée et le courant fort.",
		"choix": [
			{"libelle": "Traverser à la nage", "suite": "noyade"},
			{"libelle": "Revenir en arrière", "suite": "debut"},
		],
	},
	"arbre": {
		"texte": "Il y as beaucoup de branche.",
		"choix": [
			{"libelle": "Casser des branches", "suite": "château"},
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
	"château": {
		"texte": "Un immense château se profile a l'horizon. FIN (a suivre)",
		"choix": [],
	}
}

const DEPART = "debut"
var passage = DEPART

func _ready():
	afficher()

func afficher():
	var p = histoire[passage]
	texte.text = p["texte"]
	for bouton in boite_choix.get_children():
		bouton.queue_free()
	if p["choix"].is_empty():
		ajouter_bouton("Rejouer", DEPART)
		return
	for c in p["choix"]:
		ajouter_bouton(c["libelle"], c["suite"])
	
func ajouter_bouton(libelle, suite):
	var bouton = Button.new()
	bouton.text = libelle
	bouton.pressed.connect(aller_a.bind(suite))
	boite_choix.add_child(bouton)
	

func aller_a(suite):
	passage = suite
	afficher()
