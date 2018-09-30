extends Container

var tex_free_unchecked = preload('res://resource/icon_1_1.png')
var tex_free_checked = preload('res://resource/icon_1_2.png')
var tex_placed_unchecked = preload('res://resource/icon_2_1.png')
var tex_placed_checked = preload('res://resource/icon_2_2.png')

onready var button = self.get_node('Button')

var unit

func _ready():
	pass

func _on_TextureButton_button_down():
	for icon in self.get_parent().get_children():
		if icon != self:
			icon.get_node('Button').set('pressed', false)

func set_placed(placed):
	if placed:
		button.texture_normal = tex_placed_unchecked
		button.texture_pressed = tex_placed_checked
	else:
		button.texture_normal = tex_free_unchecked
		button.texture_pressed = tex_free_checked
		