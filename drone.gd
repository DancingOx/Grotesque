extends Area2D

onready var gui = get_node('/root/main/canvas/GUI')

var player

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		gui.set_unit_selected(self)
		#SceneTree.set_input_as_handled()

func hide():
	visible = false

func show():
	visible = true

func remove():
	if player.role == 'human':
		gui.find_icon_by_unit(self).queue_free()

	player.units.erase(self)

	player = null
		
	queue_free()
