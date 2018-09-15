extends Control

onready var map = self.get_parent().get_parent()

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		map.set_process(true)

	if event is InputEventMouseMotion:
		map.set_process(true)
