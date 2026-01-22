extends Node2D



const plane_length = 30

const node_count = plane_length * plane_length / 12
const path_count = 12

onready var point_sprite = preload("res://test1/point.tscn")


func _ready():
	var generator = preload("res://MapGenerator.gd").new()
	var map_data = generator.generate(plane_length, node_count, path_count)
	print("вершины: %s" % map_data.nodes)
	print("тропы: %s" % str(map_data.paths))
	pass


func generate():
	randomize()
	
	#1 generating points on a grid randomly
	var points = []
	points.append(Vector2(0, plane_length /2))
	points.append(Vector2(plane_length, plane_length /2))
	
	var center = Vector2(plane_length /2, plane_length /2)
	for i in range(node_count):
		while true:
			var point = Vector2(randi() % plane_length, randi() % plane_length)
			
			var dist_from_center = (point - center).length_squared()
			var in_circle = dist_from_center <= plane_length * plane_length /4
			if not points.has(point) and in_circle:
				points.append(point)
				break
	
	#2 connect points into a graph without intersecting edges
	var pool = PoolVector2Array(points)
	var triangles = Geometry.triangulate_delaunay_2d(pool)
	
	#3 finding paths from start to finish A*
	var astar = AStar2D.new()
	for i in range(points.size()):
		astar.add_point(i, points[i])
	
	for i in range(triangles.size() /3):
		var p1 = triangles[i * 3]
		var p2 = triangles[i * 3 + 1]
		var p3 = triangles[i * 3 + 2]
		if not astar.are_points_connected(p1, p2):
			astar.connect_points(p1, p2)
		if not astar.are_points_connected(p2, p3):
			astar.connect_points(p2, p3)
		if not astar.are_points_connected(p1, p3):
			astar.connect_points(p1, p3)
		
	var paths = []
	for i in range(path_count):
		var id_path = astar.get_id_path(0, 1)
		if id_path.size() == 0:
			break
		
		paths.append(id_path)
		
		#4 removing nodes/ generating unique path every time
		for j in range(randi() % 2 + 1):
			var index = randi() % (id_path.size() - 2) + 1
			var id = id_path[index]
			astar.set_point_disabled(id)
			
	return paths

