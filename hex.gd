extends Area2D

var texture_target_marker = preload('res://resource/target_marker.png')
var texture_target_marker_red = preload('res://resource/target_marker_red.png')

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
	
	var gui = $'/root/main/canvas/GUI'
	if gui.egg:
		if check_egg_can_be_placed($'/root/main/game'.human):
			gui.move_egg(self)

func on_left_click():
	var gui = $'/root/main/canvas/GUI'
	if gui.egg:
		if check_egg_can_be_placed($'/root/main/game'.human):
			gui.place_egg(self)
	else:
		map.place_selected_unit(index)

func on_right_click():
	pass

func show_captured():
	var particles = get_node("particles")
	particles.process_material = player.particles_material
	particles.emitting = true

func highlight_move_possible():
	if player and player.role == 'ai':
		coloring.texture = texture_target_marker_red
	else:
		coloring.texture = texture_target_marker

func remove_highlight():
	coloring.texture = null

func check_egg_can_be_placed(for_player):
	if for_player != player:
		return false  # hex is not owned
	
	if index in map.units_placement[player]:
		return false  # hex is occupied by unit
	
	if index in map.eggs_placement[player]:
		return false  # hex is occupied by another egg
	
	return true