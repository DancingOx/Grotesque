extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/gui')

var role
var color
var color_name
var units_texture
var egg_texture
var mox_texture

var cells = []

var units = []

var wealth

const INITIAL_WEALTH = 100
const UNIT_COSTS = {
	'drone': 100,
	'angel': 300
}

const unit_templates_by_name = {
	'drone': preload('res://unit/drone.tscn'),
	'angel': preload('res://unit/angel.tscn')
}

func _ready():
	wealth = INITIAL_WEALTH

func create_unit(template_name):
	var unit = unit_templates_by_name[template_name].instance()
	units.append(unit)

	unit.z_index = 2000

	unit.player = self
	unit.set_texture()
	
	return unit

func apply_income():
	for cell in cells:
		wealth += game.map.get_cell_income(cell)

func pay_for_new_unit(unit_type):
	var cost = UNIT_COSTS[unit_type]
	if wealth < cost:
		return false
	
	wealth -= cost

	return true

func return_new_unit_payment(unit_type):
	wealth += UNIT_COSTS[unit_type]
