extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/gui')

var drone_template = preload('res://unit/unit.tscn')

var role
var color
var color_name
var particles_material
var units_texture
var egg_texture
var mox_texture

var cells = []

var units = []

var wealth

var income_table = {
	'hangar_1': 10,
	'hangar_2': 20,
	'hangar_3': 30
}

func _ready():
	wealth = 100

func create_unit():
	var unit = drone_template.instance()
	units.append(unit)

	unit.z_index = 2000

	unit.player = self
	unit.get_node('sprite').texture = unit.player.units_texture
	
	return unit

func apply_income():
	for cell in cells:
		if cell in game.map.bonuses:
			wealth += income_table[game.map.bonuses[cell]]

const unit_cost = 300

func pay_for_new_unit():
	if wealth < unit_cost:
		return false
	
	wealth -= unit_cost

	return true

func return_new_unit_payment():
	wealth += unit_cost
