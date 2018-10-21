extends Container

var unit_icon_template = preload('res://icon_unit/icon_unit.tscn')

onready var game = get_node('/root/main/game')

func get_units_panel():
	return self.get_node('MarginContainer/VBoxContainer/BottomPanel/Left')

func _ready():
	pass

func add_unit_icon(unit):
	var icon = unit_icon_template.instance()
	icon.unit = unit
	get_units_panel().add_child(icon)
	get_units_panel().queue_sort()

func get_selected_unit_icon():
	for icon in get_units_panel().get_children():
		if icon.button.get('pressed'):
			return icon

func find_icon_by_unit(unit):
	for icon in get_units_panel().get_children():
		if icon.unit == unit:
			return icon

func set_unit_selected(unit):
	var selected_icon = get_selected_unit_icon()
	if selected_icon:
		selected_icon.button.set('pressed', false)
		selected_icon.unit.get_node('selection').visible = false

	var icon = find_icon_by_unit(unit)
	if icon:
		icon.button.set('pressed', true)
	
	icon.unit.get_node('selection').visible = true
	
	game.refresh_possible_moves_highlight()
	
func unselect_all_units():
	for icon in get_units_panel().get_children():
		icon.button.set('pressed', false)
		icon.unit.get_node('selection').visible = false

func _on_ButtonNextTurn_pressed():
	game.next_phase()

func update_wealth_indicator(wealth):
	get_node('MarginContainer/VBoxContainer/TopPanel/Left/WealthIndicator').text = str(wealth)

var egg = null
var egg_hex = null

func activate_egg_placing_mode():
	if not game.human.pay_for_new_unit():
		return
	
	enable_unit_selection(false)
	egg = load('res://egg/egg.tscn').instance()
	
	return true

func deactivate_egg_placing_mode():
	if egg:
		game.human.return_new_unit_payment()

		egg.queue_free()
		egg = null
		egg_hex = null

	$'MarginContainer/VBoxContainer/BottomPanel/HBoxContainer/AddUnitIcon/Button'.set('pressed', false)

	enable_unit_selection(true)

func move_egg(hex):
	if not egg:
		return

	if hex == egg_hex:
		return

	if egg_hex:
		egg_hex.remove_child(egg)

	hex.add_child(egg)
	egg_hex = hex

func place_egg(hex):
	if hex != egg_hex:
		move_egg(hex)

	game.map.eggs_placement[hex.player][hex.index] = egg

	$'MarginContainer/VBoxContainer/BottomPanel/HBoxContainer/AddUnitIcon/Button'.set('pressed', false)

	egg = null
	egg_hex = null
	
	enable_unit_selection(true)

func enable_unit_selection(value):
	for icon in get_units_panel().get_children():
		if value:
			icon.button.set('disabled', false)
		else:
			icon.button.set('pressed', false)
			icon.button.set('disabled', true)

func refresh_lifebars():
	for icon in get_units_panel().get_children():
		icon.lifebar.value = icon.unit.hp
