extends Area2D


onready var map = self.get_parent()

func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		map.set_process_move()
