extends Control


onready var q_image : Image
onready var options: Array = [ ]


func _on_Save_pressed():
	var q = Quastion.new()
	var type = get_node("MarginContainer/VBoxContainer/OptionButton").selected
	var text = get_node("MarginContainer/VBoxContainer/TextEdit").text
	var image = q_image
	var answer = get_node("MarginContainer/VBoxContainer/LineEdit").text
	
	q.type = type
	q.text = text
	q.image = image
	q.answer = answer
	q.options = options
	print(type)
	print(text)
	print(image)
	print(options)
	print(answer)
	
	ResourceSaver.save("res://вопросы/вопрос1.tres", q)
	
#	var saveFile = File.new()
#	saveFile.open("res://вопросы/вопрос1.json", File.WRITE)
#	saveFile.store_var(to_json(q), true)
#	saveFile.close()

func load_image(path) -> Image:
	var image = Image.new()
	image.load(path)
	return image

func _on_Load_texture_pressed(): 
	get_node("FileDialog").popup()


func _on_FileDialog_file_selected(path):
	q_image = load_image(path)


func _on_Button1_pressed(): # правильный вариант 1
	get_node("FileDialog1").popup()
func _on_FileDialog1_file_selected(path):
	options.append(load_image(path))

func _on_Button2_pressed(): # 2
	get_node("FileDialog2").popup()
func _on_FileDialog2_file_selected(path):
	options.append(load_image(path))

func _on_Button3_pressed(): # 3
	get_node("FileDialog3").popup()
func _on_FileDialog3_file_selected(path):
	options.append(load_image(path))
	
func _on_Button4_pressed(): # 4
	get_node("FileDialog4").popup()
func _on_FileDialog4_file_selected(path):
	options.append(load_image(path))
