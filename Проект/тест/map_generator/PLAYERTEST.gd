extends Node2D

onready var name_ := "" setget name_setter
onready var pos_id := 0
onready var character = get_node("character")

func setup_position(id: int, pos: Vector2) -> void:
	pos_id = id
	self.position = pos



func name_setter(value):
	name_ = value
	$nameLabel.text = value
