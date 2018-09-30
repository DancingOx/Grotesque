extends Container

var unit_icon_template = preload('res://UnitIcon.tscn')

func get_units_panel():
	return self.get_node('MarginContainer/VBoxContainer/BottomPanel/Left')

func _ready():
	pass

func add_unit_icon(unit):
	var icon = unit_icon_template.instance()
	icon.unit = unit
	get_units_panel().add_child(icon)

func get_selected_unit_icon():
	for icon in get_units_panel().get_children():
		if icon.get_node('Button').get('pressed'):
			return icon

func find_icon_by_unit(unit):
	for icon in get_units_panel().get_children():
		if icon.unit == unit:
			return icon