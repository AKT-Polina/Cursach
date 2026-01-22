extends Node2D

signal get_my_info(id, pos)
const margin = 10
onready var id 

var children: Array = []

func add_child_event(child):
	if !children.has(child):
		children.append(child)
		update()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.red)
	
	for child in children:
		var line = child.position - position
		var normal = line.normalized()
		line -= margin * normal
		var color = Color.gray
		draw_line(normal * margin, line, color, 2, true)


func _on_Button_pressed():
	emit_signal("get_my_info", self.id, self.position)
