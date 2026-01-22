extends Node

const plane_len = 60
const node_count = plane_len * plane_len / 12
const path_count = 1

const map_scale = 60

const camera_zoom = Vector2(0.05, 0.05)



var events = {}
var players_data = []
var players = []
var mapAstar : AStar2D
var event_scene = preload("res://map_generator/Event.tscn")
var water_tile = preload("res://test1/water.tscn")


onready var quastionUI = get_node("CanvasLayer/Control/taskPanel")
onready var dice = get_node("CanvasLayer/Control/dice")

func _ready():
	players_data = Global.active_user["active game"]["characters"]
	
	randomize()
	var generator = preload("res://MapGenerator.gd").new()
	var map_data = generator.generate(plane_len, node_count, path_count)
	save_map(map_data)

#	var map_data = load_map()
	
	setup_events(map_data)
	setup_players(players_data)
	var A = setup_mapAstar(map_data)
	turn(players[0], A)


func turn(player, mapAstar):
	# ожидание значения после броска кубика
	var roll = yield(dice, "rolled")
	print("игрок %s: %s"% [player, roll])
	
	# вывод вопроса
	quastionUI.roll()
	quastionUI.show()
	var correct = yield(quastionUI, "answered")
	quastionUI.clear()
	quastionUI.hide() 
	if !correct:
		return turn(next_player(player), mapAstar) # передача хода
	
	# передвижение игрока
	for i in range(roll):
		var connections =  mapAstar.get_point_connections(player.pos_id)
		if connections.size() == 1:
			player.pos_id = connections[0]; print("move %s"% player.pos_id)
			$Tween.interpolate_property(player, "position", \
				player.position, mapAstar.get_point_position(connections[0])* \
				map_scale + Vector2(300, 0), 1.0, \
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT )
			$Tween.start()
			yield($Tween, "tween_all_completed")

	turn(next_player(player), mapAstar) # передача хода


func setup_mapAstar(map_data) -> AStar2D:
	var mapAstar = AStar2D.new()
	for node in map_data.nodes:
		mapAstar.add_point(node, map_data.nodes.get(node))
	for path in map_data.paths:
		for i in range(path.size()-1):
			if mapAstar.are_points_connected(path[i], path[i+1]):
				continue
			mapAstar.connect_points(path[i], path[i+1], false)
	print(mapAstar.get_points())
	for p in mapAstar.get_points():
		print("точка %s : %s"% [p, mapAstar.get_point_connections(p)])
	return mapAstar


func next_player(player):
	var current_player = players.find(player, 0)
	var next_player
	if players.size()-1 == current_player:
		next_player = 0
	else:
		next_player = current_player + 1
	return players[next_player]


func setup_players(players_data: Array) -> void:
	var character = preload("res://game/characterOnMap.tscn")
	for p in players_data:
		var ch = character.instance()
		get_node("players").add_child(ch)
		ch.name_ = p.keys()[0]
		ch.character.load_customization(ch.name_)
		ch.pos_id = p[p.keys()[0]]
		ch.position = events[ch.pos_id].position
		players.append(ch)
		
		
#		p.position = events[0].position
	return 


func setup_events(map_data):
		# setting up events
	for k in map_data.nodes.keys():
		var point = map_data.nodes[k]
		var event = event_scene.instance()
		
		var water = water_tile.instance()
		event.position = point * map_scale + Vector2(300, 0)
		water.position = point * map_scale + Vector2(300, 0)
		event.id = k
		event.get_node("Button").text = str(k)
		add_child(event)
		events[k] = event
		
#		$BG/sprites.add_child(water)
#
#	$BG.merge()
	$BG.get_node("sprites").queue_free()
	
	for path in map_data["paths"]:
		for i in range(path.size() - 1):
			var index1 = path[i]
			var index2 = path[i + 1]
			events[index1].add_child_event(events[index2])
	pass


func load_map():
	if Global.active_user != null:
		var temp = Global.active_user
		if !temp.has("active game"):
			print("игра не найдена."); return 
		var data = preload("res://MapData.gd").new()
		var nodes = temp["active game"]["map"].get("nodes")
		var paths = temp["active game"]["map"].get("paths")
		for node in nodes: # приведение типов из json 
			var k = int(node)
			data.nodes[k] = str2var("Vector2"+nodes.get(node))
		for path in paths:
			for i in range(path.size()):
				path[i] = int(path[i])
		
		data.paths = paths
		return data
	return 


func save_map(map_data):
	if Global.active_user != null:
		var temp = Global.active_user
		temp["active game"] = {}
		temp["active game"]["map"] = {}
		temp["active game"]["map"]["nodes"] = map_data.nodes
		temp["active game"]["map"]["paths"] = map_data.paths
		
		var fileName = "user://%s.json" % Global.active_user.user.login
		var file = File.new()
		file.open(fileName, File.WRITE)
		file.store_string(JSON.print(temp, "\t"))
		file.close()
		return
	return

# движение камеры 
func _unhandled_input(event):
	if Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
		$Camera2D.zoom += camera_zoom
	if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
		$Camera2D.zoom -= camera_zoom
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		$Camera2D.offset -= event.relative * $Camera2D.zoom


