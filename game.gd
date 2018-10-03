extends Control

var map_template = preload('res://map.tscn')
var player_template = preload('res://player.tscn')

var map_name = 'default'

var map
var player

func _ready():
	map = map_template.instance()

	var scene = get_node("/root/main/game/scene")
	scene.add_child(map)
	
	player = player_template.instance()
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

func apply_turn():
	for cell in map.units_placement:
		if not player.cells.has(cell):
			player.cells.append(cell)
			map.nodes[cell].show_captured()
