extends Button

onready var self_position = $pos2d.global_position

signal cordinates(pos)



func _on_move_button_pressed():
	emit_signal("cordinates",self_position)

