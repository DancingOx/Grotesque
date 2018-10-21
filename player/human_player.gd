extends "res://player/player.gd"

func _ready():
	._ready()

	role = 'human'

	gui.update_wealth_indicator(wealth)

	print('Human player ready')

func create_unit():
	var unit = .create_unit()
	gui.add_unit_icon(unit)
	return unit

func apply_income():
	.apply_income()

	gui.update_wealth_indicator(wealth)

func pay_for_new_unit():
	if .pay_for_new_unit():
		gui.update_wealth_indicator(wealth)
		return true
	else:
		return false

func return_new_unit_payment():
	.return_new_unit_payment()
	gui.update_wealth_indicator(wealth)
