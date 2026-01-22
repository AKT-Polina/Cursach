extends Control

onready var user = Global.active_user
onready var charPanel = preload("res://menu/characterFile.tscn")
onready var selected: Array = []
onready var characters_node = get_node("CenterContainer/VBoxContainer/Panel/vb_chars")

func _ready():
	if user == null:
		print("нет пользователя"); return
	if user.has("characters"):
		for character in user["characters"]:
			var charFile = charPanel.instance()
			characters_node.add_child(charFile)
			charFile.ch_name.text = character
			var ch_name: String 
			ch_name = charFile.ch_name.text
			charFile.connect("toggled", self, "change_characters", [ch_name])
			charFile.character.load_customization(character)
		pass
	pass


func _on_Button_pressed():
	get_tree().change_scene("res://menu/characterCreator.tscn")
	pass # Replace with function body.


func change_characters(button_pressed, ch_name):
	if button_pressed:
		selected.append({ch_name : 0})
	else: 
		selected.erase(ch_name)
	print(selected)
	Global.active_user["active game"]["characters"] = selected


func _on_delete_pressed():
	var fileName = "user://%s.json" % Global.active_user.user.login
	var file = File.new()
	if file.file_exists(fileName):
		file.open(fileName, File.READ)
		var temp = parse_json(file.get_as_text())
		file.close()
		for ch in selected:
			temp["characters"].erase(ch.keys()[0])
		file.open(fileName, File.WRITE)
		file.store_string(JSON.print(temp, "\t"))
		file.close()
		
		Global.active_user = temp
		print("персонажи удалены")
		get_tree().reload_current_scene()


func _on_select_pressed():
	get_tree().change_scene("res://map_generator/Map.tscn")
	pass # Replace with function body.
