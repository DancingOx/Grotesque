extends Area2D

var hex_texture_cyan = preload('res://resource/coloring_cyan.png')


var index

onready var map = self.get_parent().get_parent()
onready var coloring = get_node("coloring")

func _ready():
	pass
	#print(self.get_path())
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		map.clicked.append(self)
		map.set_process_click(event.button_index)

	elif event is InputEventMouseMotion:
		map.moved.append(self)
		map.set_process_move()

func on_move():
	map.pointer.visible = true
	map.pointer.set_position(self.position - Vector2(0, -35))

func on_left_click():
	map.place_unit(index)

func on_right_click():
	map.take_off_unit(index)
	
	#coloring.texture = hex_texture_cyan