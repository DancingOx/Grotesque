extends Control

var map_template = preload('res://map/map.tscn')
var player_template = preload('res://player/player.tscn')

var map_name = 'default'

var map
var human
var opponent

var turn = 1
var phase = 0

func _ready():
	human = player_template.instance()
	human.role = 'human'
	human.color = Color(0.0, 0.9, 0.9, 0.9)
	#human.particles_material = load('res://hex/crosses_material_blue.tres')
	human.units_material = load('res://unit/fire_material_blue.tres')
	human.egg_texture = preload('res://resource/egg.png')
	human.mox_texture = preload('res://resource/mox_blue.png')
	self.add_child(human)

	opponent = player_template.instance()
	opponent.role = 'ai'
	opponent.color = Color(0.9, 0.9, 0.0, 0.9)
	#opponent.particles_material = load('res://hex/crosses_material_green.tres')
	opponent.units_material = load('res://unit/fire_material_green.tres')
	opponent.egg_texture = preload('res://resource/egg_green.png')
	opponent.mox_texture = preload('res://resource/mox_green.png')
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

	$'/root/main/canvas/gui'.unselect_all_units()

	set_units_unpickable(false)

func to_plan_phase():
	# battle
	for cell1 in map.units_placement[human]:
		for cell2 in map.units_placement[opponent]:
			if cell1 == cell2:
				var unit1 = map.units_placement[human][cell1]
				var unit2 = map.units_placement[opponent][cell2]

				unit1.hp -= unit2.attack
				unit2.hp -= unit1.attack

				if unit1.hp <= 0:
					unit1.remove()
					map.units_placement[human].erase(cell1)

				if unit2.hp <= 0:
					unit2.remove()
					map.units_placement[opponent].erase(cell2)

	$'/root/main/canvas/gui'.refresh_lifebars()

	for egg_cell in map.eggs_placement[human].keys():
		var broken = false
		for unit_cell in map.units_placement[opponent]:
			if egg_cell == unit_cell:
				map.smash_egg(egg_cell)
				broken = true
				break
		if not broken:
			map.hatch_egg(egg_cell)

	for egg_cell in map.eggs_placement[opponent].keys():
		var broken = false
		for unit_cell in map.units_placement[human]:
			if egg_cell == unit_cell:
				map.smash_egg(egg_cell)
				broken = true
				break
		if not broken:
			map.hatch_egg(egg_cell)

	for unit in opponent.units:
		unit.hide()

	human.apply_income()
	opponent.apply_income()

	for player in map.units_placement:
		for cell in map.units_placement[player]:
			map.capture_cell(cell, player)

	map.highlight_border_cells(human)

	set_units_unpickable(true)
	
	turn += 1
	get_node('/root/main/canvas/gui/MarginContainer/VBoxContainer/TopPanel/Right/Turn').text = 'Turn %s' % turn

func set_units_unpickable(value):
	for unit in human.units:
		unit.input_pickable = value
	for unit in opponent.units:
		unit.input_pickable = value

func make_random_moves(player):
	var defenders = 0

	var contact_cells = map.get_contact_cells(player)
	var contact_count = contact_cells.size()
	if contact_count:
		defenders = randi() % int(min(player.units.size(), contact_count))
		for i in range(defenders):
			map.place_unit(player.units[i], contact_cells[randi() % contact_count])
	
	print('contact_count', contact_count)
	print('defenders', defenders)
	
	var border_cells = map.get_random_border_cells(player, player.units.size())
	for i in range(min(border_cells.size(), player.units.size() - defenders)):
		map.place_unit(player.units[i + defenders], border_cells[i])

	while true:
		var cell = map.get_random_safe_free_cell(player)
		if cell == null:
			cell = map.get_random_free_cell(player)
		if cell == null:
			break  # all posessed cells are occupied
		
		if not player.pay_for_new_unit():
			break  # no enouth wealth

		map.place_new_egg(cell)