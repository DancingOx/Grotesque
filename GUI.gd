extends Container

var unit_icon_template = preload('res://UnitIcon.tscn')

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
		if icon.get_node('Button').get('pressed'):
			return icon

func find_icon_by_unit(unit):
	for icon in get_units_panel().get_children():
		if icon.unit == unit:
			return icon

func set_unit_selected(unit):
	var selected_icon = get_selected_unit_icon()
	if selected_icon:
		selected_icon.get_node('Button').set('pressed', false)

	find_icon_by_unit(unit).get_node('Button').set('pressed', true)

func _on_ButtonNextTurn_pressed():
	game.apply_turn()

