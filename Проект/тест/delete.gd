extends Node2D

var off2

func _ready():
	var curve = $Path2D.get_curve()
	$text.text = str(curve.get_baked_points())
	print(curve.get_baked_length())
	print(curve.get_closest_offset($"2".position))
	off2 = curve.get_closest_offset($"2".position)
	print(curve.get_closest_point($"2".position))
	pass



#func _on_move_button_pressed(position):
#	print(position)
#	get_node("Path2D/player").move_to_offset(off2)
#	pass # Replace with function body.
