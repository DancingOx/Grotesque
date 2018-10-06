extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/GUI')

var drone_template = preload('res://drone.tscn')

var role
var color
var particles_material
var units_material

var cells = []

var units = []

func _ready():
	pass

func create_unit():
	var unit = drone_template.instance()
	units.append(unit)

	unit.z_index = 2000
	
	if role == 'human':
		gui.add_unit_icon(unit)
	else:
		unit.hide()

	unit.player = self
	unit.get_node('particles').process_material = units_material
	
	return unit