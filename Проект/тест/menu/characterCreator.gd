extends Control


onready var character_name = null

func _ready():
	if Global.active_user:
		$character.load_customization(null)
	else: 
		$character.load_customization(null)


func _on_saveButton_pressed():
	$character.save_customization(character_name)
	print("сохранение %s" %character_name)
	
	get_tree().change_scene("res://menu/gameOptions.tscn")


func _on_nameEdit_text_changed(new_text):
	character_name = new_text










func _on_OptionButton_item_selected(index):
	$character.change_hairstyle(index)


func _on_ColorPickerButton_color_changed(color):
	$character/hair.modulate = color


func _on_R_value_changed(value):
	$character/hair.modulate.r = value
func _on_G_value_changed(value):
	$character/hair.modulate.g = value
func _on_B_value_changed(value):
	$character/hair.modulate.b = value


func _on_hair_color_changed(color):
	$character/hair.modulate = color
func _on_body_color_changed(color):
	$character/body.modulate = color
func _on_eyes_color_changed(color):
	$character/eyeball.modulate = color
func _on_shirt_color_changed(color):
	$character/shirt.modulate = color 
func _on_shorts_color_changed(color):
	$character/shorts.modulate = color
