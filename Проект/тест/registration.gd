extends Control

onready var login = get_node("VBox/Login")
onready var password = get_node("VBox/Password")
onready var password2 = get_node("VBox/Password2")
onready var info = get_node("VBox/infoLabel")


func _on_backButton_pressed(): # назад
	get_tree().change_scene("res://autharization.tscn")


func _on_acceptButton_pressed(): # подтвердить
	var tmp = { "user": {
		"login": login.text, "password": password.text
		}
	}
	var file_name = "user://%s.json" % login.text
	var file = File.new()
	
	$AnimationPlayer.play("def")
	if login.text == "" || password.text == "" || password2.text == "":
		info.text = "Заполните пустые поля."; file.close()
		return
	if file.file_exists(file_name):
		info.text = "Пользователь уже существует."; file.close() 
		return
	if password.text != password2.text:
		info.text = "Введенные пароли не совпадают."; file.close()
		return
	
	
	file.open(file_name, File.WRITE)
	file.store_string(JSON.print(tmp, "\t"))
	file.close()
	$Center/AcceptDialog.popup()


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://autharization.tscn")


func _on_Button_pressed(): # загрузить картинку
	$FileDialog.popup()
#	OS.shell_open("C://")
	pass


func _on_FileDialog_file_selected(path): # выбрать картинку
	print(path)
	var image = Image.new()
	image.load(path)
	var t = ImageTexture.new()
	t.create_from_image(image)
	$_/TextureRect.texture = t
