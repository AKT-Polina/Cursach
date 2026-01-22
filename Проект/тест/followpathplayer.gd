extends PathFollow2D

var moving = false
var speed = 500
var stop_offset = 0

func _ready():
	pass


func _process(delta):
	if offset < stop_offset:
		offset += speed*delta
	elif offset > stop_offset:
		offset -= speed*delta
	print(self.position)

func move_to_offset(off: float) -> void:
	stop_offset = off


func _on_move_button_cordinates(pos):
	var curve = get_parent().get_curve()
	stop_offset = curve.get_closest_offset(pos)
	print (curve.get_closest_offset(pos))

