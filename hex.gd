extends Area2D

var hex_texture_cyan = preload('res://resource/coloring_cyan.png')
var hex_texture_stripes = preload('res://resource/coloring_stripes.png')

var index
var player

var income

onready var map = self.get_parent().get_parent()
onready var coloring = get_node("coloring")


func _ready():
	income = 10 + 5 * (randi() % 5)
	get_node('income').text = str(income)
	get_node('income').set("custom_colors/font_color", Color(0.3 + 0.03 * income, 0.7, 0.2, 1.0))

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
	map.place_selected_unit(index)

func on_right_click():
	pass

func show_captured():
	var particles = get_node("particles")
	particles.process_material = player.particles_material
	particles.emitting = true

func highlight_move_possible():
	coloring.texture = hex_texture_stripes

func remove_highlight():
	coloring.texture = null
