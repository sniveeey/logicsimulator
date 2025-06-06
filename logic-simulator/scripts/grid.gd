extends Node2D
var on = true
var mode = ""
var image = Image.new()
var texture = ImageTexture.new()
var rotated = 0
var globalPosition : Vector2
var startPos : Vector2
#var endPos : Vector2
var pressTime : int
@onready var game: Node2D = $".."
@onready var placer: TileMapLayer = $"../Placer"
@onready var hud: CanvasLayer = $"../HUD"
@onready var wires: Node2D = $"../Wires"

func _ready() -> void:
	game.connect("mode", modeChange)

func _draw():
	if on: 
		var size = get_viewport_rect().size * get_parent().get_node("Camera2D").zoom * 5
		var cam = get_parent().get_node("Camera2D").position
		var zoom = get_parent().get_node("Camera2D").zoom
		var mousePosition = get_viewport().get_mouse_position()
		var gridSize = 32
		
		if Input.is_action_just_pressed("rotate"):
			if rotated >= 3:
				rotated = 0
			else:
				rotated += 1
		
		for i in range(int((cam.x - size.x) / gridSize) - 1, int((size.x + cam.x) / gridSize) + 1):
			draw_line(Vector2(i * gridSize, cam.y + size.y + 100), Vector2(i * gridSize, cam.y - size.y - 100), "A1CDA8")
			
		for i in range(int((cam.y - size.y) / gridSize) - 1, int((size.y + cam.y) / gridSize) + 1):
			draw_line(Vector2(cam.x + size.x + 100, i * gridSize), Vector2(cam.x - size.x - 100, i * gridSize), "A1CDA8")
			
		draw_line(Vector2(16383, cam.y + size.y + 100), Vector2(16383, cam.y - size.y - 100), "FF0000")
		draw_line(Vector2(-16383, cam.y + size.y + 100), Vector2(-16383, cam.y - size.y - 100), "FF0000")
		draw_line(Vector2(cam.x + size.x + 100, 16383), Vector2(cam.x - size.x - 100, 16383), "FF0000")
		draw_line(Vector2(cam.x + size.x + 100, -16383), Vector2(cam.x - size.x - 100, -16383), "FF0000")
		draw_circle(Vector2.ZERO, 3, "FFFFFF", true)
		draw_rect(placer.rect, Color(1, 1, 1, 0.3), true)
		
		if mode != "":
			if cam.x >= 0:
				var mouseBoxX = floor(round((gridSize * zoom.x) - ((cam.x - (floor(cam.x / gridSize) * gridSize)) * zoom.x) - mousePosition.x) / (gridSize * zoom.x)) * -1
				var mouseBoxY = floor(round((gridSize * zoom.y) - ((cam.y - (floor(cam.y / gridSize) * gridSize)) * zoom.y) - mousePosition.y) / (gridSize * zoom.y)) * -1
				#printt(mouseBoxX, mouseBoxY)
				texture = load("res://sprites/" + mode + ".png")
				image = texture.get_image()
				for i in rotated:
					image.rotate_90(CLOCKWISE)
				texture = ImageTexture.create_from_image(image)
				#draw_line(Vector2((mouseBoxX + 1) * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize), (mouseBoxY + 1) * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)), Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)), "FFFFFF")
				draw_rect(Rect2(Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)), Vector2(32, 32)), Color(1, 1, 1, 0.5), true)
				draw_texture(texture, Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)))
				#print(floor(round((gridSize * zoom.x) - ((cam.x - (floor(cam.x / gridSize) * gridSize)) * zoom.x) - mousePosition.x) / (gridSize * zoom.x)) * -1, " ", zoom.x)
				if mousePosition.x < (720 if hud.get_child(0).gateOut == true else 816):
					var x = round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize)) / gridSize + 512
					var y = round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)) / gridSize + 512
					if Input.is_action_just_pressed("left_click"):
						changeDic(x, y, mode, rotated)
					elif Input.is_action_pressed("right_click") && placer.get_dic(x, y).Type != "Empty":
						wires.undoArray.append([{"gate": {"x": x, "y": y, "cell": placer.get_dic(x, y).Type, "rotate": placer.get_dic(x, y).Rotation}, "type": "deleteGate"}])
						changeDic(x, y, "Empty", rotated)
						"""for wire in wires.allWires:
							var x = round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (floor(cam.x / gridSize) * gridSize)) + 16384
							var y = round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (floor(cam.y / gridSize) * gridSize)) + 16384
							#printt(wire, x, y)
							if (wire.start.x == x + 28 || wire.end.x == x) && (wire.start.y == y + 14 || wire.end.y == y + 14 || wire.start.y == y + 9 || wire.end.y == y + 9 || wire.start.y == y + 19 || wire.end.y == y + 19):
								wires.allWires.remove_at(wires.allWires.find(wire))
								#print(wires.allWires)"""
			elif cam.x < 0:
				var mouseBoxX = floor(round((gridSize * zoom.x) - ((cam.x - (ceil(cam.x / gridSize) * gridSize)) * zoom.x) - mousePosition.x) / (gridSize * zoom.x)) * -1
				var mouseBoxY = floor(round((gridSize * zoom.y) - ((cam.y - (ceil(cam.y / gridSize) * gridSize)) * zoom.y) - mousePosition.y) / (gridSize * zoom.y)) * -1
				texture = load("res://sprites/" + mode + ".png")
				image = texture.get_image()
				for i in rotated:
					image.rotate_90(CLOCKWISE)
				texture = ImageTexture.create_from_image(image)
				#draw_line(Vector2((mouseBoxX + 1) * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize), (mouseBoxY + 1) * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)), Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)), "FFFFFF")
				draw_rect(Rect2(Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)), Vector2(32, 32)), Color(1, 1, 1, 0.5), true)
				draw_texture(texture, Vector2(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize), mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)))
				if mousePosition.x < (720 if hud.get_child(0).gateOut == true else 816):
					var x = round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize)) / gridSize + 512
					var y = round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)) / gridSize + 512
					if Input.is_action_just_pressed("left_click"):
						#print(round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize)) / gridSize + 512)
						changeDic(x, y, mode, rotated)
					elif Input.is_action_pressed("right_click") && placer.get_dic(x, y).Type != "Empty":
						wires.undoArray.append([{"gate": {"x": x, "y": y, "cell": placer.get_dic(x, y).Type, "rotate": placer.get_dic(x, y).Rotation}, "type": "deleteGate"}])
						changeDic(x, y, "Empty", rotated)
						"""for wire in wires.allWires:
							var x = round(mouseBoxX * gridSize - ((size.x / zoom.x / 10) / zoom.x) + (ceil(cam.x / gridSize) * gridSize)) + 16384
							var y = round(mouseBoxY * gridSize - ((size.y / zoom.y / 10) / zoom.y) + (ceil(cam.y / gridSize) * gridSize)) + 16384 + 14
							printt(wire, x, y)
							if (wire.start.x == x + 28 || wire.end.x == x) && (wire.start.y == y || wire.end.y == y || wire.start.y == y + 9 || wire.end.y == y + 9 || wire.start.y == y + 19 || wire.end.y == y + 19):
								wires.allWires.remove_at(wires.allWires.find(wire))
								print(wires.allWires)"""
		else:
			if mousePosition.x < (720 if hud.get_child(0).gateOut == true else 816) && !wires.activeWires:
				if Input.is_action_just_pressed("left_click"):
					startPos = round(globalPosition)
					pressTime = Time.get_ticks_msec()
				elif Input.is_action_just_released("left_click"):
					startPos = Vector2.ZERO
					#endPos = globalPosition
				
				if startPos != Vector2.ZERO && wires.movingWire == []:
					draw_rect(Rect2(startPos, Vector2(round(globalPosition - startPos))), Color(1, 1, 1, 0.5), true)

func _process(delta: float) -> void:
	queue_redraw()
	globalPosition = get_global_mouse_position()

func modeChange(newMode: String) -> void:
	mode = newMode

func changeDic(x: int, y: int, cell: String, rotate: int) -> void:
	placer.changeDic.emit(x, y, cell, rotate)
