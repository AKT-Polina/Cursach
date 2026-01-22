extends Control


onready var login = get_node("VBoxContainer/Login")
onready var password = get_node("VBoxContainer/Password")
onready var info_label = get_node("VBoxContainer/infoLabel")


func _on_loginButton_pressed(): #при нажатии на кнопку
	var fileName = "user://%s.json" % login.text
	var file = File.new()
	if not file.file_exists(fileName):
		info_label.text = "Учетная запись не найдена"
#		return
	else:
		file.open(fileName, File.READ)
		var temp = parse_json(file.get_as_text())
		if password.text == temp["user"]["password"]:
			info_label.text = "Добро пожаловать, %s!" % temp["user"]["login"]
			Global.active_user = temp
			file.close()
			get_tree().change_scene("res://menu/mainMenu.tscn")
		else:
			info_label.text = "Неверный пароль"
	$AnimationPlayer.play("def")
	file.close()


func _on_regButton_pressed():
	get_tree().change_scene("res://registration.tscn")
