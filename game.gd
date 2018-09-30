extends Node2D

var map_template = preload('res://map.tscn')
var player_template = preload('res://player.tscn')

var map_name = 'default'

var map

func _ready():
	map = map_template.instance()

	var scene = get_node("/root/main/game/scene")
	scene.add_child(map)
	
	var player = player_template.instance()
	self.add_child(player)
	
	print('GAME READY')
	
	set_process(true)
	
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_K and not event.echo:
			pass

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
