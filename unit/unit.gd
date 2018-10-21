extends Area2D

onready var gui = get_node('/root/main/canvas/gui')

var player

const max_hp = 0
var hp = max_hp

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			gui.set_unit_selected(self)
			get_tree().set_input_as_handled()

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

var shifted = false

func shift():
	if shifted:
		return
	
	if player.role == 'human':
		self.position.x += 20
	else:
		self.position.x -= 20
	
	shifted = true

func shift_back():
	if not shifted:
		return

	if player.role == 'human':
		self.position.x -= 20
	else:
		self.position.x += 20
	
	shifted = false