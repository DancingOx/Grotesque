extends Area2D

var i
var j

onready var map = self.get_parent().get_parent().get_parent()

func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		map.clicked.append(self)
		map.set_process(true)

	if event is InputEventMouseMotion:
		map.moved.append(self)
		map.set_process(true)

func on_move():
	print('MOVED [%s : %s]' % [i, j])

func on_click():
	print('CLICKED [%s : %s]' % [i, j])
