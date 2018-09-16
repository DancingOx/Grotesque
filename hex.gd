extends Area2D

var hex_texture_cyan = preload('res://resource/coloring_cyan.png')

var i
var j

onready var map = self.get_parent().get_parent()
onready var coloring = get_node("coloring")

func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			map.clicked.append(self)
			map.set_process_click()

	elif event is InputEventMouseMotion:
		map.moved.append(self)
		map.set_process_move()

func on_move():
	map.pointer.visible = true
	map.pointer.set_position(self.position - Vector2(0, -35))

func on_click():
	print('CLICKED [%s : %s]' % [i, j])
	coloring.texture = hex_texture_cyan