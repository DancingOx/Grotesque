extends Control

var map_template = preload('res://map.tscn')

var map_name = 'default'

var map

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	map = map_template.instance()

	#var map_data = load('res://maps/%s.gd' % map_name).new().data
	#for item in map_data:
	#	terrain.set_cell(item.i, item.j, item.v)

	var scene = get_node("/root/game/scene")
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
		
#	print('--->', str(Engine.get_frames_per_second()))
