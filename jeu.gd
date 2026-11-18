extends Control

@onready var texte = $VBoxContainer/Texte
@onready var choix1 = $VBoxContainer/Choix1
@onready var choix2 = $VBoxContainer/Choix2
@onready var choix3 = $VBoxContainer/Choix3

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

var passage = "debut"

func _ready():
	choix1.pressed.connect(_on_choix.bind(0))
	choix2.pressed.connect(_on_choix.bind(1))
	choix3.pressed.connect(_on_choix.bind(2))
	afficher()

func afficher():
	var p = histoire[passage]
	texte.text = p["texte"]
	var boutons = [choix1, choix2, choix3]
	for i in boutons.size():
		if i < p["choix"].size():
			boutons[i].text = p["choix"][i]["libelle"]
			boutons[i].visible = true
		else:
			boutons[i].visible = false

func _on_choix(index):
	passage = histoire[passage]["choix"][index]["suite"]
	afficher()
