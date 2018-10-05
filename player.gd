extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/GUI')

var drone_template = preload('res://drone.tscn')

var cells = []

var units = []

func _ready():
	pass

func create_unit():
	var unit = drone_template.instance()
	units.append(unit)

	unit.z_index = 2000
	
	gui.add_unit_icon(unit)
	
	return unit