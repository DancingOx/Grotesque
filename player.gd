extends Control

onready var game = get_node('/root/main/game')
onready var gui = get_node('/root/main/canvas/GUI')

var drone_template = preload('res://drone.tscn')

var role
var color
var particles_material
var units_material
var egg_texture
var mox_texture

var cells = []

var units = []

var wealth

func _ready():
	wealth = 100
	if role == 'human':
		gui.update_wealth_indicator(wealth)

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

func apply_income():
	for cell in cells:
		wealth += game.map.nodes[cell].income

	if role == 'human':
		gui.update_wealth_indicator(wealth)

const unit_cost = 300

func pay_for_new_unit():
	if wealth < unit_cost:
		return false
	
	wealth -= unit_cost
	
	gui.update_wealth_indicator(wealth)

	return true