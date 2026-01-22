extends Button

var rect: Rect2 
var color: Color = Color(0, 0, 0)
signal color_changed(color)


func _ready():
	rect.size += Vector2(20,10)
	print(self.get_global_rect())
#	emit_signal("pressed")
	pass

func _on_R_value_changed(value):
	color.r = value
	emit_signal("color_changed", color)
func _on_G_value_changed(value):
	color.g = value
	emit_signal("color_changed", color)
func _on_B_value_changed(value):
	color.b = value
	emit_signal("color_changed", color)

func _on_colorChanger_pressed():
	if $panel.is_visible_in_tree():
		$panel.hide()
	else: 
		$panel.popup(self.get_global_rect().grow_individual( \
				-self.rect_size.x,0,180,0))


func _on_colorChanger_color_changed(color):
	$ColorRect.color = color


func _on_panel_focus_exited():
	$panel.hide()
