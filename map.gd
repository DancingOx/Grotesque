extends Control


var hex_template = preload('res://hex.tscn')

var x0 = -550
var y0 = 525

var a = 256 / 2;
#var h = a * cos(PI / 6.0);
var h = 55;

var order = 5

var side = 2 * order - 1;

var total = 3 * pow(order, 2) - 3 * order + 1;

var min_sum = side - order;
var max_sum = 2 * side - order;

var moved = []
var clicked = []

onready var hexes = get_node("hexes")
onready var pointer = get_node('pointer')

var map = {}
var cells = []

func _init_cells():
	for i in range(side):
		for j in range(side):
			var s = i + j
			if s >= min_sum and s < max_sum:
				cells.append([i, j])

func _generate():
	randomize()
	for cell in cells:
		if rand_range(1, 10) > 2:
			map[cell] = 1
		else:
			map[cell] = 0

func _fill():
	for cell in cells:
		if not map[cell]:
			continue
		
		var i = cell[0]
		var j = cell[1]

		var s = i + j
		var d = i - j
		
		var hex = hex_template.instance()
		
		hex.rect_position = Vector2(x0 + float(s) * 1.5 * a, y0 + float(d) * h)

		var sprite = hex.get_node('area')
		sprite.z_index = d
		sprite.i = i
		sprite.j = j
		
		hexes.add_child(hex)

func _ready():
	set_process(false)
	
	_init_cells()
	_generate()
	_fill()
		
	print('MAP READY')

func _process_moved():
	if not moved:
		pointer.visible = false
		return

	var current = moved.front()
	for hex in moved:
		if hex.z_index > current.z_index:
			current = hex

	moved.clear()
	current.on_move()
	pointer.visible = true
	pointer.position = current.get_parent().rect_position - Vector2(2, 7)

func _process_clicked():
	if not clicked:
		return

	var current = clicked.front()
	for hex in clicked:
		if hex.z_index > current.z_index:
			current = hex

	pointer.visible = true
	clicked.clear()
	current.on_click()

func _process(delta):
	set_process(false)

	_process_moved()
	_process_clicked()
