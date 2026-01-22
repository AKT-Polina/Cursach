extends Control

var players
onready var panel = preload("res://characterPanel.tscn")

func _ready():
	var loadFile = File.new() #открывает поток
	if not loadFile.file_exists("res://save.json"): #если загружаемого файла не существует:
		return
	else:
		loadFile.open("res://save.json", File.READ) #открывает файл для чтения
		var temp = parse_json(loadFile.get_as_text()) #вроде как текст открывает
		players = temp #записывает в словарь значение из файла
		loadFile.close() #закрывает файл
	for player in players:
		var p = panel.instance()
		p.get_node("Label").text = str(player)
		get_node("VBox").add_child(p)
		p.connect("send", self, "check_mouse")

func check_mouse(text):
	print("mouse_entered on button: " + str(text))


func _on_Button_pressed():
	get_tree().change_scene("res://newPlayer.tscn")
