extends Control

onready var userLabel = get_node("CenterContainer/MarginContainer/HBoxContainer/MarginContainer/Label")


func _ready():
	if Global.active_user:
		userLabel.text = "Аккаунт: " + Global.active_user["user"]["login"]
	else: 
		userLabel.text = "Нет пользователя"


func _on_Button2_pressed():
	get_tree().change_scene("res://menu/gameOptions.tscn")
	pass # Replace with function body.
