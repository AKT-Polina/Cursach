extends Button
signal rolled(number)

func _on_dice_pressed():
	randomize()
	var roll = randi()% 6+1
	self.text = str(roll)
	emit_signal("rolled", roll)
