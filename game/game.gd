extends Control

var map_template = preload('res://map/map.tscn')

var human_player_template = preload('res://player/human_player.tscn')
var ai_player_template = preload('res://player/ai_player.tscn')

var map_name = 'default'

var map
var human
var opponent

var turn = 1
var phase = 0

var players = []

func _ready():
	human = human_player_template.instance()
	human.color = Color(0.0, 0.9, 0.9, 0.9)
	human.color_name = 'blue'
	human.units_texture = load('res://resource/angel_blue.png')
	human.egg_texture = preload('res://resource/egg.png')
	human.mox_texture = preload('res://resource/mox_blue.png')
	players.append(human)
	self.add_child(human)

	opponent = ai_player_template.instance()
	opponent.color = Color(0.9, 0.9, 0.0, 0.9)
	opponent.color_name = 'green'
	opponent.units_texture = load('res://resource/angel_green.png')
	opponent.egg_texture = preload('res://resource/egg_green.png')
	opponent.mox_texture = preload('res://resource/mox_green.png')
	players.append(opponent)
	self.add_child(opponent)

	var scene = get_node("/root/main/game/scene")
	map = map_template.instance()
	scene.add_child(map)
	
	$'scene/camera'.set_limits()
	
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
	opponent.place_eggs()
	opponent.make_random_moves()
	
	$'/root/main/canvas/gui'.unselect_all_units()
	set_units_pickable(false)
	map.clear_possible_moves_highlight()

	show_enemy_units()

	shift_units()

	damage_units()

func to_plan_phase():
	perish_units()

	$'/root/main/canvas/gui'.refresh_lifebars()
		
	damage_and_hatch_eggs()

	apply_income()

	hide_enemy_units()

	capture_cells()

	set_units_pickable(true)
	
	increment_turn()

	shift_units_back()

func damage_units():
	for cell1 in map.units_placement[human]:
		for cell2 in map.units_placement[opponent]:
			if cell1 == cell2:
				var unit1 = map.units_placement[human][cell1]
				var unit2 = map.units_placement[opponent][cell2]

				var damage1 = unit2.attack
				unit1.hp -= damage1
				unit1.take_damage(damage1)

				var damage2 = unit1.attack
				unit2.hp -= damage2
				unit2.take_damage(damage2)

func perish_units():
	for player in players:
		for cell in map.units_placement[player]:
			var unit = map.units_placement[player][cell]
			if unit.hp <= 0:
				unit.remove()
				map.units_placement[player].erase(cell)

func damage_and_hatch_eggs():
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

func show_enemy_units():
	for unit in opponent.units:
		unit.show()

func hide_enemy_units():
	for unit in opponent.units:
		unit.hide()

func apply_income():
	human.apply_income()
	opponent.apply_income()

func capture_cells():
	for player in map.units_placement:
		for cell in map.units_placement[player]:
			var the_only_one = true
			for other_player in map.units_placement:
				if other_player == player:
					continue
				if cell in map.units_placement[other_player]:
					the_only_one = false
					break
			if the_only_one:
				map.capture_cell(cell, player)

func increment_turn():
	turn += 1
	get_node('/root/main/canvas/gui/MarginContainer/VBoxContainer/TopPanel/Right/Turn').text = 'Turn %s' % turn

func shift_units():
	for cell1 in map.units_placement[human]:
		for cell2 in map.units_placement[opponent]:
			if cell1 == cell2:
				var unit1 = map.units_placement[human][cell1]
				var unit2 = map.units_placement[opponent][cell2]

				unit1.shift()
				unit2.shift()

func shift_units_back():
	for unit in human.units:
		unit.shift_back()
	for unit in opponent.units:
		unit.shift_back()

func set_units_pickable(value):
	for unit in human.units:
		unit.input_pickable = value
	for unit in opponent.units:
		unit.input_pickable = value

func get_current_unit():
	var icon = $'/root/main/canvas/gui'.get_selected_unit_icon()
	return icon.unit if icon else null

func refresh_possible_moves_highlight():
	map.clear_possible_moves_highlight()
	var unit = get_current_unit()
	if unit:
		map.highlight_possible_moves(unit)
