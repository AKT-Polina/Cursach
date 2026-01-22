extends Node2D

onready var map_data
onready var astar
onready var current_node_id = 0 
onready var tween = get_node("Tween")
onready var block_otl = false








func move_to(next_node_id, pos):
	var astar = get_a_star()
	if astar.are_points_connected(current_node_id, next_node_id):
		current_node_id = next_node_id
		# animation stuff
		tween.interpolate_property(self, "position",
				self.position, pos, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
	else:
		return

func get_a_star():
	var astar = AStar2D.new()
	for node in map_data.nodes:
		astar.add_point(node, map_data.nodes.get(node))
	for path in map_data.paths:
		for i in range(path.size() - 1):
			if not astar.are_points_connected(path[i], path[i+1]):
				print("connecting... %s %s" % [path[i], path[i+1]])
				astar.connect_points(path[i], path[i+1])
	print(astar.get_points())
	return astar
