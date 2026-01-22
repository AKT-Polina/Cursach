extends Control
onready var skin = preload("res://skinChange.tscn")
onready var gender = preload("res://genderChangePanel.tscn")
func _ready():
	pass # Replace with function body.




func _on_genderButton_pressed():
	$VBoxContainer/Label.text = "Выбрать пол"
	var g = gender.instance()
	get_node("Panel").add_child(g)

func _on_skinButton_pressed():
	$VBoxContainer/Label.text = "Выбрать цвет кожи"
	var s = skin.instance()
	get_node("Panel").add_child(s)


func _on_hairstyleButton_pressed():
	$VBoxContainer/Label.text = "Выбрать причёску"


func _on_sweaterButton_pressed():
	$VBoxContainer/Label.text = "Выбрать одежду"


func _on_bootsButton_pressed():
	$VBoxContainer/Label.text = "Выбрать обувь"


func _on_backButton_pressed():
	get_tree().change_scene("res://regForm.tscn")


func _on_okButton_pressed():
	get_tree().change_scene("res://regForm.tscn")


func _on_iconButton_pressed():
	$VBoxContainer/Label.text = "Выбрать аватар"
