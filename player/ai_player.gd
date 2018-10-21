extends "res://player/player.gd"

func _ready():
	._ready()

	print('AI player ready')

func create_unit():
	var unit = .create_unit()
	unit.hide()
	return unit
