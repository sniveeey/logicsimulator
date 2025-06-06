extends TileMapLayer

var gridSize = 512
var Dic = {}
var rect : Rect2
signal changeDic(x, y, cell, rotate)
@onready var grid: Node2D = $"../Grid"
@onready var wires: Node2D = $"../Wires"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in gridSize * 2:
		for y in gridSize * 2:
			Dic[str(Vector2(x, y))] = {
				"Type": "Empty"
			}
			#set_cell(Vector2(x - gridSize, y - gridSize), randi_range(0, 1), Vector2i(0, 0), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousePosition = get_viewport().get_mouse_position()
	var size = get_viewport_rect().size * get_parent().get_node("Camera2D").zoom * 5
	var cam = get_parent().get_node("Camera2D").position
	var zoom = get_parent().get_node("Camera2D").zoom
	var gridSize = 32
	var tile_pos: Vector2
	var globalPosition = floor(grid.globalPosition + Vector2(16384, 16384))
	
	if cam.x >= 0:
		var mouseBoxX = floor(round((gridSize * zoom.x) - ((cam.x - (floor(cam.x / gridSize) * gridSize)) * zoom.x) - mousePosition.x) / (gridSize * zoom.x)) * -1
		var mouseBoxY = floor(round((gridSize * zoom.y) - ((cam.y - (floor(cam.y / gridSize) * gridSize)) * zoom.y) - mousePosition.y) / (gridSize * zoom.y)) * -1
		tile_pos = Vector2(round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize)) / gridSize + 512, round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)) / gridSize + 512)
	else:
		var mouseBoxX = floor(ceil((gridSize * zoom.x) - ((cam.x - (ceil(cam.x / gridSize) * gridSize)) * zoom.x) - mousePosition.x) / (gridSize * zoom.x)) * -1
		var mouseBoxY = floor(ceil((gridSize * zoom.y) - ((cam.y - (ceil(cam.y / gridSize) * gridSize)) * zoom.y) - mousePosition.y) / (gridSize * zoom.y)) * -1
		tile_pos = Vector2(round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize)) / gridSize + 512, round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)) / gridSize + 512)
	
	# Wires section
	if tile_pos.x >= 0 && tile_pos.y >= 0:
		if _cell_to_input(Dic[str(tile_pos)]["Type"]) == 1:
			if globalPosition.x >= tile_pos.x * gridSize && globalPosition.x <= tile_pos.x * gridSize + 3 && wires.activeWires == true:
				if globalPosition.y >= tile_pos.y * gridSize + 14 && globalPosition.y <= tile_pos.y * gridSize + 17:
					rect = Rect2(Vector2(tile_pos.x * gridSize - 16384, tile_pos.y * gridSize + 14 - 16384), Vector2(4, 4))
					if Input.is_action_just_released("left_click") && wires.activeWires == true:
						wires.endPoint = Vector2(tile_pos.x * gridSize, tile_pos.y * gridSize + 14)
				else:
					rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			elif globalPosition.x >= tile_pos.x * gridSize + 28 && globalPosition.x <= tile_pos.x * gridSize + 32 && wires.activeWires == false:
				if globalPosition.y >= tile_pos.y * gridSize + 14 && globalPosition.y <= tile_pos.y * gridSize + 17:
					rect = Rect2(Vector2(tile_pos.x * gridSize + 28 - 16384, tile_pos.y * gridSize + 14 - 16384), Vector2(4, 4))
					if Input.is_action_just_pressed("left_click") && wires.activeWires == false:
						wires.activeWires = true
						wires.startPoint = Vector2(tile_pos.x * gridSize + 28, tile_pos.y * gridSize + 14)
			else:
				rect = Rect2(Vector2.ZERO, Vector2.ZERO)
		elif _cell_to_input(Dic[str(tile_pos)]["Type"]) == 2:
			if globalPosition.x >= tile_pos.x * gridSize && globalPosition.x <= tile_pos.x * gridSize + 3 && wires.activeWires == true:
				if globalPosition.y >= tile_pos.y * gridSize + 9 && globalPosition.y <= tile_pos.y * gridSize + 12:
					rect = Rect2(Vector2(tile_pos.x * gridSize - 16384, tile_pos.y * gridSize + 9 - 16384), Vector2(4, 4))
					if Input.is_action_just_released("left_click") && wires.activeWires == true:
						wires.endPoint = Vector2(tile_pos.x * gridSize, tile_pos.y * gridSize + 9)
				elif globalPosition.y >= tile_pos.y * gridSize + 19 && globalPosition.y <= tile_pos.y * gridSize + 22:
					rect = Rect2(Vector2(tile_pos.x * gridSize - 16384, tile_pos.y * gridSize + 19 - 16384), Vector2(4, 4))
					if Input.is_action_just_released("left_click") && wires.activeWires == true:
						wires.endPoint = Vector2(tile_pos.x * gridSize, tile_pos.y * gridSize + 19)
				else:
					rect = Rect2(Vector2.ZERO, Vector2.ZERO)
			elif globalPosition.x >= tile_pos.x * gridSize + 28 && globalPosition.x <= tile_pos.x * gridSize + 32 && wires.activeWires == false:
				if globalPosition.y >= tile_pos.y * gridSize + 14 && globalPosition.y <= tile_pos.y * gridSize + 17:
					rect = Rect2(Vector2(tile_pos.x * gridSize + 28 - 16384, tile_pos.y * gridSize + 14 - 16384), Vector2(4, 4))
					if Input.is_action_just_pressed("left_click") && wires.activeWires == false:
						wires.activeWires = true
						wires.startPoint = Vector2(tile_pos.x * gridSize + 28, tile_pos.y * gridSize + 14)
			else:
				rect = Rect2(Vector2.ZERO, Vector2.ZERO)
		else:
			rect = Rect2(Vector2.ZERO, Vector2.ZERO)

func get_dic(x, y) -> Dictionary:
	return(Dic[str(Vector2(x, y))])

func _on_change_dic(x, y, cell, rotate) -> void:
	Dic[str(Vector2(x, y))] = {"Type": cell, "Rotation": rotate}
	#print(x, " ", y, " ", cell, " ", (x * 1024) + y)
	#print(Dic[(x * 1024) + y])
	var coord1 : int
	var coord2 : int
	if rotate > 0 && rotate < 3:
		coord1 = 1
	else:
		coord1 = 0
	if rotate >= 2:
		coord2 = 1
	else:
		coord2 = 0
	#printt(rotate, coord1, coord2)
	set_cell(Vector2(x - gridSize, y - gridSize), _change_cell_to_num(cell), Vector2i(coord1, coord2), 0)

# Big match case incoming
func _change_cell_to_num(cell: String) -> int:
	match cell:
		"Empty":
			return 0
		"not_gate":
			return 1
		"and_gate":
			return 2
		"nand_gate":
			return 3
		"or_gate":
			return 4
		"nor_gate":
			return 5
		"xor_gate":
			return 6
		"xnor_gate":
			return 7
		_:
			return 0

func _cell_to_input(cell: String) -> int:
	match cell:
		"Empty":
			return 0
		"not_gate":
			return 1
		"and_gate":
			return 2
		"nand_gate":
			return 2
		"or_gate":
			return 2
		"nor_gate":
			return 2
		"xor_gate":
			return 2
		"xnor_gate":
			return 2
		_:
			return 3
