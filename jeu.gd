extends Control

# Raccourcis vers les nœuds de la scène
@onready var texte = $VBoxContainer/Texte
@onready var choix1 = $VBoxContainer/Choix1
@onready var choix2 = $VBoxContainer/Choix2

# Où en est le joueur dans l'histoire
var passage = "debut"

func _ready():
	choix1.pressed.connect(_on_choix.bind(1))
	choix2.pressed.connect(_on_choix.bind(2))
	afficher()

func afficher():
	choix1.visible = true
	choix2.visible = true
	if passage == "debut":
		texte.text = "Tu te réveilles dans une forêt sombre. Un sentier part vers le nord, une rivière coule à l'est."
		choix1.text = "Suivre le sentier"
		choix2.text = "Aller vers la rivière"
	elif passage == "sentier":
		texte.text = "Le sentier mène à une cabane éclairée."
		choix1.text = "Frapper à la porte"
		choix2.text = "Revenir en arrière"
	elif passage == "riviere":
		texte.text = "L'eau est glacée et le courant fort."
		choix1.text = "Traverser à la nage"
		choix2.text = "Revenir en arrière"
	elif passage == "cabane":
		texte.text = "Une vieille dame t'accueille au chaud. FIN (bonne)"
		choix1.visible = false
		choix2.visible = false
	elif passage == "noyade":
		texte.text = "Le courant t'emporte... FIN (mauvaise)"
		choix1.visible = false
		choix2.visible = false

func _on_choix(numero):
	if passage == "debut":
		if numero == 1:
			passage = "sentier"
		else:
			passage = "riviere"
	elif passage == "sentier":
		if numero == 1:
			passage = "cabane"
		else:
			passage = "debut"
	elif passage == "riviere":
		if numero == 1:
			passage = "noyade"
		else:
			passage = "debut"
	afficher()
