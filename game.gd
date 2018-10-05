extends Control

var map_template = preload('res://map.tscn')
var player_template = preload('res://player.tscn')

var map_name = 'default'

var map
var player

func _ready():
	player = player_template.instance()
	self.add_child(player)
	
	var scene = get_node("/root/main/game/scene")
	map = map_template.instance()
	scene.add_child(map)
	
	print('GAME READY')
	
	set_process(true)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_K and not event.echo:
			pass

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func apply_turn():
	for cell in map.units_placement:
		map.capture_cell(cell, player)
	
	for cell in map.nodes:
		map.nodes[cell].remove_highlight()
	
	map.highlight_border_cells(player)