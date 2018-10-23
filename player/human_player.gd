extends "res://player/player.gd"

func _ready():
	._ready()

	role = 'human'

	gui.update_wealth_indicator(wealth)

	print('Human player ready')

func create_unit(template_name):
	var unit = .create_unit(template_name)
	gui.add_unit_icon(unit)
	return unit

func apply_income():
	.apply_income()

	gui.update_wealth_indicator(wealth)

func pay_for_new_unit(unit_type):
	if .pay_for_new_unit(unit_type):
		gui.update_wealth_indicator(wealth)
		return true
	else:
		return false

func return_new_unit_payment(unit_type):
	.return_new_unit_payment(unit_type)
	gui.update_wealth_indicator(wealth)
