extends Button

signal send(text)

func _ready():
	pass # Replace with function body.

func _on_characterPanel_pressed():
	emit_signal("send", $Label.text) # Replace with function body.
