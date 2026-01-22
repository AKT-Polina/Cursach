extends Panel

export(String, FILE, "*.json") var quastion_array
onready var checkBoxPanel = preload("res://вопросы/panels/CheckBoxPanel.tscn")
onready var problem_label = $Vb1/RichTextLabel
onready var answers_ = $Vb1/Vb2

onready var answer: Array = []
onready var quastions
onready var q 


signal answered(correct)


func _ready():
	quastions = load_quastions()


func load_quastions():
	var file = File.new()
	var arr: Array
	file.open(quastion_array, File.READ)
	arr = parse_json(file.get_as_text())
	file.close()
	return arr


func roll_quastion(quastions: Array) -> Dictionary:
	randomize()
	var r  = randi()% quastions.size()
	return quastions[r]


func show_quastion(quastion: Dictionary) -> void:
	var id = 1
	problem_label.bbcode_text = quastion["quastion"].get("problem")
	for a in quastion["quastion"]["options"]:
		var panel = checkBoxPanel.instance()
		answers_.add_child(panel)
		panel.id = id
		panel.checkbox.connect("toggled", self, "add_answer", [id])
		panel.content.bbcode_text = a
		id += 1
	if str(quastion["quastion"].get("answer")).length() == 1:
		var button_group = ButtonGroup.new()
		for node in answers_.get_children():
			node.checkbox.set_button_group(button_group)
	return
	
	
func add_answer(button_pressed, id):
	print("%s на кнопке %s" % [button_pressed,id])
	if button_pressed:
		answer.append(id)
	else: 
		if answer.has(id): answer.erase(id)
	answer.sort()
	print (answer)


func clear() -> void:
	get_node("otvet/Label").text = ""
	problem_label.bbcode_text = ""
	answer = []
	for node in answers_.get_children():
		answers_.remove_child(node)
		node.queue_free()


func roll() -> void:
	q = roll_quastion(quastions)
	show_quastion(q)
	return


func _on_otvet_pressed():
	var answer_string: String = "" 
	for a in answer: 
		answer_string += str(a)
	if str(q["quastion"].get("answer")) == answer_string:
		get_node("otvet/Label").text = "ВЕРНО!"
		emit_signal("answered", true)
	else: 
		get_node("otvet/Label").text = "НЕВЕРНО!"
		emit_signal("answered", false)


