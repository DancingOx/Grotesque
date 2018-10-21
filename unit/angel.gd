extends "res://unit/unit.gd"

const max_hp = 100
const attack = 30

const steps = 2
const flying = true

const textures = {
	'blue': preload('res://resource/angel_blue.png'),
	'green': preload('res://resource/angel_green.png')
}

func set_texture():
	$'sprite'.texture = textures[player.color_name]
