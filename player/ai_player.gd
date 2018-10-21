extends "res://player/player.gd"

func _ready():
	._ready()

	role = 'ai'

	print('AI player ready')

func create_unit():
	var unit = .create_unit()
	unit.hide()
	return unit

func make_random_moves():
	var map = game.map

	var defenders = 0

	var contact_cells = map.get_contact_cells(self)
	var contact_count = contact_cells.size()
	if contact_count:
		defenders = randi() % int(min(units.size(), contact_count))
		for i in range(defenders):
			map.place_unit(units[i], contact_cells[randi() % contact_count])
	
	var border_cells = map.get_random_border_cells(self, units.size())
	for i in range(min(border_cells.size(), units.size() - defenders)):
		map.place_unit(units[i + defenders], border_cells[i])

	while true:
		var cell = map.get_random_safe_free_cell(self)
		if cell == null:
			cell = map.get_random_free_cell(self)
		if cell == null:
			break  # all posessed cells are occupied
		
		if not pay_for_new_unit():
			break  # no enouth wealth

		map.place_new_egg(cell)