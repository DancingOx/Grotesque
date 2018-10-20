extends MarginContainer

func _ready():
	pass

func _on_Button_pressed():
	var gui = get_node('/root/main/canvas/gui')
	if $'Button'.pressed:
		if not gui.activate_egg_placing_mode():
			$'Button'.set('pressed', false)
	else:
		gui.deactivate_egg_placing_mode()
