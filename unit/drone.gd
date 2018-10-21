extends "res://unit/unit.gd"

const max_hp = 40
const attack = 10

const steps = 1
const flying = false

const textures = {
	'blue': preload('res://resource/drone_blue.png'),
	'green': preload('res://resource/drone_green.png')
}

func set_texture():
	$'sprite'.texture = textures[player.color_name]
