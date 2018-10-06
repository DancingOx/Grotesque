extends Control

var map_template = preload('res://map.tscn')
var player_template = preload('res://player.tscn')

var map_name = 'default'

var map
var human
var opponent

var phase = 0

func _ready():
	human = player_template.instance()
	human.role = 'human'
	human.color = Color(0.0, 0.9, 0.9, 0.5)
	human.particles_material = load('res://crosses_material.tres')
	human.units_material = load('res://fire_material_blue.tres')
	self.add_child(human)

	opponent = player_template.instance()
	opponent.role = 'ai'
	opponent.color = Color(0.0, 0.9, 0.0, 0.5)
	opponent.particles_material = load('res://crosses_material2.tres')
	opponent.units_material = load('res://fire_material_green.tres')
	self.add_child(opponent)

	var scene = get_node("/root/main/game/scene")
	map = map_template.instance()
	scene.add_child(map)
	
	print('GAME READY')
	
	set_process(true)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_K and not event.echo:
			pass

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func next_phase():
	if phase == 0:
		to_show_phase()
		phase = 1
	else:
		to_plan_phase()
		phase = 0
	
func to_show_phase():
	for cell in map.nodes:
		map.nodes[cell].remove_highlight()
	
	make_random_moves(opponent)
	
	for unit in opponent.units:
		unit.show()

	get_node('/root/main/canvas/GUI').unselect_all_units()

	set_units_unpickable(false)

func to_plan_phase():
	# battle
	for cell1 in map.units_placement[human]:
		for cell2 in map.units_placement[opponent]:
			if cell1 == cell2:
				map.units_placement[human][cell1].remove()
				map.units_placement[opponent][cell2].remove()
				map.units_placement[human].erase(cell1)
				map.units_placement[opponent].erase(cell2)
	
	for unit in opponent.units:
		unit.hide()

	for player in map.units_placement:
		for cell in map.units_placement[player]:
			map.capture_cell(cell, player)

	map.highlight_border_cells(human)

	set_units_unpickable(true)

func set_units_unpickable(value):
	for unit in human.units:
		unit.input_pickable = value
	for unit in opponent.units:
		unit.input_pickable = value

func make_random_moves(player):
	var cells = map.get_random_border_cells(player, player.units.size())
	
	for i in range(cells.size()):
		map.place_unit(player.units[i], cells[i])
