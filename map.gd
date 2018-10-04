extends Control

onready var gui = get_node('/root/main/canvas/GUI')

var hex_template = preload('res://hex.tscn')

var x0 = -550
var y0 = 510

var a = 256 / 2;
var h = 55;

var order = 5

var side = 2 * order - 1;

var total = 3 * pow(order, 2) - 3 * order + 1;

var min_sum = side - order;
var max_sum = 2 * side - order;

var moved = []
var process_move = false
var clicked = []
var button_index = 0
var process_click = false

onready var hexes = get_node("hexes")
onready var pointer = get_node('pointer')

var map = {}
var cells = []
var nodes = {}

var units_placement = {}

func _init_cells():
	for i in range(side):
		for j in range(side):
			var s = i + j
			if s >= min_sum and s < max_sum:
				cells.append([i, j])

func _generate():
	randomize()
	for cell in cells:
		if rand_range(1, 10) > 2:
			map[cell] = 1
		else:
			map[cell] = 0

func _fill():
	for cell in cells:
		if not map[cell]:
			continue

		var i = cell[0]
		var j = cell[1]

		var s = i + j
		var d = i - j
		
		var hex = hex_template.instance()

		hex.set_position(Vector2(x0 + float(s) * 1.5 * a, y0 + float(d) * h))

		hex.z_index = d - 1000
		hex.index = cell

		hexes.add_child(hex)

		nodes[cell] = hex

func get_random_cell():
	while true:
		var cell = cells[randi() % cells.size()]
		if map[cell] != 0:
			return cell

func _set_random_starting_cell():
	var cell = get_random_cell()
	var player = get_node('/root/main/game').player
	capture_cell(cell, player)

func _ready():
	set_process(false)

	_init_cells()
	_generate()
	_fill()
	
	_set_random_starting_cell()

	print('MAP READY')

func set_process_move():
	process_move = true
	set_process(true)

func set_process_click(value):
	process_click = true
	button_index = value
	set_process(true)

func _process_moved():
	if not moved:
		pointer.visible = false
		return

	var current = moved.front()
	for hex in moved:
		if hex.z_index > current.z_index:
			current = hex

	moved.clear()
	process_move = false

	current.on_move()

func _process_clicked():
	if not clicked:
		return

	var current = clicked.front()
	for hex in clicked:
		if hex.z_index > current.z_index:
			current = hex

	clicked.clear()
	process_click = false
	
	if button_index == BUTTON_LEFT:
		current.on_left_click()
	else:
		current.on_right_click()

func _process(delta):
	set_process(false)

	if process_move:
		_process_moved()

	if process_click:
		_process_clicked()


func place_unit(index):
	var icon = gui.get_selected_unit_icon()
	if not icon:
		return  # no unit selected

	if units_placement.has(index):
		return  # cell is already occupied

	var unit = icon.unit

	var current_location = unit.get_parent()
	if current_location:
		current_location.remove_child(unit)
		units_placement.erase(current_location.index)

	units_placement[index] = unit

	nodes[index].add_child(unit)

	icon.set_placed(true)

func take_off_unit(index):
	if not units_placement.has(index):
		return  # cell is already free

	var unit = units_placement[index]

	var current_location = nodes[index]
	if not current_location:
		print('Unit location inconsistency')
		return
		
	units_placement.erase(index)
	
	current_location.remove_child(unit)

	gui.find_icon_by_unit(unit).set_placed(false)

func capture_cell(cell, player):
	if not player.cells.has(cell):
		player.cells.append(cell)
		nodes[cell].show_captured()
	