extends Node2D

var dict 
onready var hair_i = 0
onready var hair_styles = [
preload("res://assets/character png/grayscale/hairA.png"), \
preload("res://assets/character png/grayscale/hairB.png"), \
preload("res://assets/character png/grayscale/hairC.png"), \
preload("res://assets/character png/grayscale/hairD.png") ]


func _ready():
#	var fileName = "user://admin.json"
#	var file = File.new()
#	file.open(fileName, File.READ)
#	Global.active_user = parse_json(file.get_as_text())
	# отладка №№№№№№№№№№№№№

	load_customization(null)
	pass


func change_hairstyle(index):
	get_node("hair").texture = hair_styles[index]
	hair_i = index
	pass


func save_customization(character):
	if Global.active_user == null:
		print("нет пользователя"); return
		
	var file_name = "user://%s.json" % Global.active_user.user.login
	var file = File.new()
	file.open(file_name, File.READ)
	var temp = parse_json(file.get_as_text())
	file.close()
	if !temp.has("characters"):
		temp["characters"] = { }
	if !temp["characters"].has("%s"%character):
		temp["characters"]["%s"%character] = { }
	temp["characters"]["%s"%character]["hair_type"] = hair_i
	temp["characters"]["%s"%character]["hair"] = $hair.modulate.to_html()
	temp["characters"]["%s"%character]["eyeball"] = $eyeball.modulate.to_html()
	temp["characters"]["%s"%character]["body"] = $body.modulate.to_html()
	temp["characters"]["%s"%character]["shirt"] = $shirt.modulate.to_html()
	temp["characters"]["%s"%character]["shorts"] = $shorts.modulate.to_html()

	file.open(file_name, File.WRITE)
	file.store_string(JSON.print(temp, "\t"))
	file.close()
	
	Global.active_user = temp; print(temp)


func load_customization(character):
	if Global.active_user == null:
		load_default_coloring(); return
	if character == null:
		load_default_coloring(); return

	var file_name = "user://%s.json" % Global.active_user.user.login
	var file = File.new()
	if not file.file_exists(file_name):
		load_default_coloring(); return
		
	file.open(file_name, File.READ)
	var temp = parse_json(file.get_as_text())
	if !temp.has("characters"):
		load_default_coloring(); return
	if !temp["characters"].has("%s"%character):
		load_default_coloring(); return
	if !temp["characters"]["%s"%character].has_all( \
	["hair", "eyeball", "body", "shirt", "shorts", "hair_type"]):
		load_default_coloring(); return
		
	$hair.texture = hair_styles[temp["characters"]["%s"%character]["hair_type"]]
	$hair.set_modulate(Color(temp["characters"]["%s"%character]["hair"]))
	$eyeball.set_modulate(temp["characters"]["%s"%character]["eyeball"])
	$body.set_modulate(temp["characters"]["%s"%character]["body"])
	$shirt.set_modulate(temp["characters"]["%s"%character]["shirt"])
	$shorts.set_modulate(temp["characters"]["%s"%character]["shorts"])
	file.close()


func load_default_coloring():
	$hair.texture = hair_styles[0]
	$hair.set_modulate(Color(0.5, 0.5, 0.5, 1))
	$eyeball.set_modulate(Color(0.5, 0.9, 0.5, 1))
	$body.set_modulate(Color(0.9, 0.5, 0.5, 1))
	$shirt.set_modulate(Color(0.5, 0.5, 0.5, 1))
	$shorts.set_modulate(Color(0.5, 0.5, 0.9, 1))

