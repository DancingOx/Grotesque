extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/gui')

var drone_template = preload('res://unit/unit.tscn')

var role
var color
var color_name
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

const INITIAL_WEALTH = 100
const UNIT_COST = 300

func _ready():
	wealth = INITIAL_WEALTH

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

func pay_for_new_unit():
	if wealth < UNIT_COST:
		return false
	
	wealth -= UNIT_COST

	return true

func return_new_unit_payment():
	wealth += UNIT_COST
