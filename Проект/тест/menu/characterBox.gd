tool
extends Control


func _on_characterBox_resized():
	self.get_child(0).position = self.rect_size /2
	pass # Replace with function body.
