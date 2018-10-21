extends "res://player/player.gd"

func _ready():
	._ready()

	role = 'ai'

	print('AI player ready')

func create_unit(template_name):
	var unit = .create_unit(template_name)
	unit.hide()
	return unit

func make_random_moves():
	var map = game.map

	var defenders = 0

	var contact_cells = map.get_contact_cells(self)
	var contact_count = contact_cells.size()
	if contact_count and units.size():
		defenders = randi() % int(min(units.size(), contact_count))
		for i in range(defenders):
			map.place_unit(units[i], contact_cells[randi() % contact_count])

	var used_cells = []
	for i in range(units.size() - defenders):
		var unit = units[i + defenders]

		var most_valuable_cell = null
		var max_income = 0
		for cell in map.get_possible_moves(unit):
			if cell in used_cells:
				continue
			var income = map.get_cell_income(cell)
			if income >= max_income:
				max_income = income
				most_valuable_cell = cell
		
		if most_valuable_cell:
			used_cells.append(most_valuable_cell)
			map.place_unit(unit, most_valuable_cell)

func place_eggs():
	var map = game.map

	while true:
		var cell = map.get_random_safe_free_cell(self)
		if cell == null:
			cell = map.get_random_free_cell(self)
		if cell == null:
			break  # all posessed cells are occupied
		
		if not pay_for_new_unit():
			break  # no enouth wealth

		map.place_new_egg(cell)