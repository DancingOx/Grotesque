extends Area2D

onready var gui = get_node('/root/main/canvas/GUI')

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		gui.set_unit_selected(self)