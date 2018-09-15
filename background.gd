extends Area2D


onready var map = self.get_parent()

func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		map.set_process(true)

	if event is InputEventMouseMotion:
		map.set_process(true)
