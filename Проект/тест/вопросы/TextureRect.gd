extends TextureRect


func _ready():
	pass


func _on_TextureRect_focus_entered():
	self_modulate = "ff0000"
	pass # Replace with function body.


func _on_TextureRect_focus_exited():
	self_modulate = "ffffff"
	pass # Replace with function body.


func _on_TextureRect_mouse_entered():
	self_modulate = "ff0000"
	pass # Replace with function body.


func _on_TextureRect_mouse_exited():
	self_modulate = "ffffff"
	pass # Replace with function body.
