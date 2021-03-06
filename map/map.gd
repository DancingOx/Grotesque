extends Control

onready var gui = get_node('/root/main/canvas/gui')

var hex_template = preload('res://hex/hex.tscn')
var egg_template = preload('res://egg/egg.tscn')

var x0 = -550
var y0 = 510

var a = 256 / 2;
var h = 55;

var order = 6

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
var posession = {}
var units_placement = {}
var eggs_placement = {}
var bonuses = {}

var bonus_textures = {
	'hangar_1_neutral': preload('res://resource/hangar_1_neutral.png'),
	'hangar_2_neutral': preload('res://resource/hangar_2_neutral.png'),
	'hangar_3_neutral': preload('res://resource/hangar_3_neutral.png'),
	'hangar_1_blue': preload('res://resource/hangar_1_blue.png'),
	'hangar_2_blue': preload('res://resource/hangar_2_blue.png'),
	'hangar_3_blue': preload('res://resource/hangar_3_blue.png'),
	'hangar_1_green': preload('res://resource/hangar_1_green.png'),
	'hangar_2_green': preload('res://resource/hangar_2_green.png'),
	'hangar_3_green': preload('res://resource/hangar_3_green.png')
}

var income_table = {
	'hangar_1': 10,
	'hangar_2': 20,
	'hangar_3': 30
}

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

		var bonus = rand_range(1, 10)
		if  bonus > 8:
			bonuses[cell] = 'hangar_3'
		elif bonus > 7:
			bonuses[cell] = 'hangar_2'
		elif bonus > 5:
			bonuses[cell] = 'hangar_1'

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
		hex.get_node('collider').z_index = d - 1000

		hexes.add_child(hex)
		
		if cell in bonuses:
			hex.get_node('bonus').visible = true
			hex.get_node('bonus').texture = bonus_textures['%s_neutral' % bonuses[cell]]

		nodes[cell] = hex

func get_random_cell():
	while true:
		var cell = cells[randi() % cells.size()]
		if map[cell] != 0 and not cell in posession:
			return cell

func _set_random_starting_position(player):
	units_placement[player] = {}
	eggs_placement[player] = {}
	
	var starting_cells
	while true:
		starting_cells = []

		var cell = get_random_cell()
		starting_cells.append(cell)

		for neighbor_cell in get_random_neighbor_cells(cell, 2):
			starting_cells.append(neighbor_cell)

		if starting_cells.size() == 3:
			break
	
	for cell in starting_cells:
		capture_cell(cell, player)

	place_unit(player.create_unit('angel'), starting_cells[0])
	place_unit(player.create_unit('drone'), starting_cells[1])
	place_unit(player.create_unit('drone'), starting_cells[2])

func _ready():
	set_process(false)

	_init_cells()
	_generate()
	_fill()
	
	var player = get_node('/root/main/game').human
	_set_random_starting_position(player)

	var opponent = get_node('/root/main/game').opponent
	_set_random_starting_position(opponent)

	print('MAP READY')

func get_neighbor_cells(cell):
	var i = cell[0]
	var j = cell[1]

	var neighbors = []

	for d in [[1, 0], [0, 1], [-1, 0], [0, -1], [1, -1], [-1, 1]]:
		var di = d[0]
		var dj = d[1]
		var neighbor_cell = [i + di, j + dj]
		if neighbor_cell in cells:
			neighbors.append(neighbor_cell)

	return neighbors

func get_random_neighbor_cells(cell, count):
	var neighbors = get_neighbor_cells(cell)
	var selected = []
	for x in range(count):
		if neighbors:
			var pos = randi() % neighbors.size()
			var index = neighbors[pos]
			if map[index] and not index in posession:
				selected.append(index)
				neighbors.remove(pos)
	return selected

func get_possible_moves(unit):
	var player = unit.player
	
	var possible_moves = []
	
	for cell in player.cells:
		for neighbor_cell in get_neighbor_cells(cell):
			if not neighbor_cell in possible_moves and not neighbor_cell in player.cells and neighbor_cell in nodes:
				possible_moves.append(neighbor_cell)
	
	if unit.flying:
		var cells_to_fly = []
		for i in range(unit.steps - 1):
			var more_cells_to_fly = []
			for cell in possible_moves + cells_to_fly:
				for neighbor_cell in get_neighbor_cells(cell):
					if not neighbor_cell in possible_moves and not neighbor_cell in player.cells:
						more_cells_to_fly.append(neighbor_cell)
			cells_to_fly += more_cells_to_fly
		for cell in cells_to_fly:
			if cell in nodes:
				possible_moves.append(cell)
	else:
		for i in range(unit.steps - 1):
			var more_possible_moves = []
			for cell in possible_moves:
				for neighbor_cell in get_neighbor_cells(cell):
					if not neighbor_cell in possible_moves and not neighbor_cell in player.cells and neighbor_cell in nodes:
						more_possible_moves.append(neighbor_cell)
			possible_moves += more_possible_moves

	return possible_moves

func highlight_possible_moves(unit):
	for cell in get_possible_moves(unit):
		nodes[cell].highlight_move_possible()

func clear_possible_moves_highlight():
	for cell in nodes:
		nodes[cell].remove_highlight()

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

func place_selected_unit(index):
	var icon = gui.get_selected_unit_icon()
	if not icon:
		return  # no unit selected

	place_unit(icon.unit, index)

	icon.set_placed(true)

func place_unit(unit, index):
	var player = unit.player

	if units_placement[player].has(index):
		return  # cell is already occupied by another unit

	if eggs_placement[player].has(index):
		return  # cell is already occupied by egg

	if not index in player.cells and not index in get_possible_moves(unit):
		return  # cell is unreachable

	var current_hex = unit.get_parent()
	if current_hex:
		units_placement[unit.player].erase(current_hex.index)
		current_hex.remove_child(unit)

	units_placement[unit.player][index] = unit

	nodes[index].add_child(unit)

func capture_cell(cell, player):
	if not player.cells.has(cell):
		player.cells.append(cell)
		var hex = nodes[cell]
		if hex.player:
			hex.player.cells.erase(cell)
		hex.player = player
		hex.show_captured()
		posession[cell] = player

		nodes[cell].get_node('mox').set('visible', true)
		nodes[cell].get_node('mox').set('texture', player.mox_texture)

func smash_egg(index):
	var player = posession[index]
	eggs_placement[player][index].queue_free()
	eggs_placement[player].erase(index)

func hatch_egg(index):
	var player = posession[index]
	var unit_type = eggs_placement[player][index].unit_type
	smash_egg(index)
	var unit = player.create_unit(unit_type)
	place_unit(unit, index)
	
func get_random_free_cell(player):
	var free_cells = []
	for cell in player.cells:
		if cell in units_placement[player]:
			continue
		if cell in eggs_placement[player]:
			continue
		if cell in bonuses:
			continue
		
		free_cells.append(cell)
	
	if not free_cells:
		return null
	
	return free_cells[randi() % free_cells.size()]

func get_random_safe_free_cell(player):
	var contact_cells = get_contact_cells(player)
	
	var free_cells = []
	for cell in player.cells:
		if cell in units_placement[player]:
			continue
		if cell in eggs_placement[player]:
			continue
		if cell in bonuses:
			continue
		if cell in contact_cells:
			continue
		
		free_cells.append(cell)
	
	if not free_cells:
		return null
	
	return free_cells[randi() % free_cells.size()]

func place_new_egg(index, unit_type):
	var player = posession[index]
	if not player:
		return
	
	var new_egg = egg_template.instance()
	new_egg.unit_type = unit_type
	new_egg.get_node('Sprite').set('texture', player.egg_texture)
	nodes[index].add_child(new_egg)
	eggs_placement[player][index] = new_egg

func get_contact_cells(player):
	var contact_cells = []
	
	for cell in player.cells:
		for neighbor_cell in get_neighbor_cells(cell):
			if neighbor_cell in posession and posession[neighbor_cell] != player:
				if not neighbor_cell in contact_cells:
					contact_cells.append(cell)
	
	return contact_cells

func get_cell_income(cell):
	if cell in bonuses:
		return income_table[bonuses[cell]]
	else:
		return 0
