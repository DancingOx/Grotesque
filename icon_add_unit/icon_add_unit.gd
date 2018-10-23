extends MarginContainer

export var unit_type = 'angel'
export(ImageTexture) var texture_normal_custom
export(ImageTexture) var texture_pressed_custom

func _ready():
	$'Button'.texture_normal = texture_normal_custom
	$'Button'.texture_pressed = texture_pressed_custom

func _on_Button_pressed():
	var gui = get_node('/root/main/canvas/gui')
	if $'Button'.pressed:
		if not gui.activate_egg_placing_mode(unit_type):
			$'Button'.set('pressed', false)
	else:
		gui.deactivate_egg_placing_mode()
