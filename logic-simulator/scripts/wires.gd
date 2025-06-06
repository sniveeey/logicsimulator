extends Node2D

var allWires : Array
var activeWires : bool
var startPoint : Vector2
var endPoint : Vector2
var globalPosition : Vector2
var selectedWire : Array
var hoveredWire : Rect2
var undoArray : Array
var redoArray : Array
var movingWire : Array
@onready var grid: Node2D = $"../Grid"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	if activeWires == true:
		if round(globalPosition.x) >= startPoint.x - 16384 + 2:
			draw_line(Vector2(startPoint.x - 16384 + 1, startPoint.y - 16384 + 2), Vector2(round(globalPosition.x), startPoint.y - 16384 + 2), "054A91", 2.0)
			draw_line(Vector2(round(globalPosition.x) - 1, startPoint.y - 16384 + 1), Vector2(round(globalPosition.x) - 1, round(globalPosition.y) - 1), "E54B4B", 2.0)
		elif round(globalPosition.x) < startPoint.x - 16384 + 2:
			draw_line(Vector2(startPoint.x - 16384 + 2, startPoint.y - 16384 + 3), Vector2(startPoint.x - 16384 + 2, round(globalPosition.y)), "E54B4B", 2.0)
			draw_line(Vector2(startPoint.x - 16384 + 3, round(globalPosition.y) + 1), Vector2(round(globalPosition.x), round(globalPosition.y) + 1), "054A91", 2.0)
	
	for wire in allWires:
		if wire.end.x >= wire.start.x:
			if wire.start.y == wire.end.y:
				draw_line(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 2), Vector2(wire.end.x - 16384 + 3, wire.start.y - 16384 + 2), "054A91", 2.0)
			elif wire.start.y > wire.end.y:
				draw_line(Vector2(wire.end.x - 16384 + 2, wire.start.y - 16384 + 3), Vector2(wire.end.x - 16384 + 2, wire.end.y - 16384 + 1), "E54B4B", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 2), Vector2(wire.end.x - 16384 + 3, wire.start.y - 16384 + 2), "054A91", 2.0)
				#draw_line(Vector2(wire.end.x - 16384 + 2, wire.start.y - 16384 + 3), Vector2(wire.end.x - 16384 + 2, wire.end.y - 16384 + 1), "E54B4B", 2.0)
			elif wire.start.y < wire.end.y:
				draw_line(Vector2(wire.end.x - 16384 + 2, wire.start.y - 16384 + 1), Vector2(wire.end.x - 16384 + 2, wire.end.y - 16384 + 3), "E54B4B", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 2), Vector2(wire.end.x - 16384 + 3, wire.start.y - 16384 + 2), "054A91", 2.0)
				#draw_line(Vector2(wire.end.x - 16384 + 2, wire.start.y - 16384 + 3), Vector2(wire.end.x - 16384 + 2, wire.end.y - 16384 + 3), "E54B4B", 2.0)
		elif wire.end.x < wire.start.x:
			if wire.start.y == wire.end.y:
				draw_line(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 2), Vector2(wire.end.x - 16384 + 1, wire.end.y - 16384 + 2), "054A91", 2.0)
			elif wire.start.y > wire.end.y:
				draw_line(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 2), Vector2(wire.end.x - 16384 + 1, wire.end.y - 16384 + 2), "054A91", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 2, wire.start.y - 16384 + 3), Vector2(wire.start.x - 16384 + 2, wire.end.y - 16384 + 3), "E54B4B", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 2), Vector2(wire.end.x - 16384 + 1, wire.end.y - 16384 + 2), "054A91", 2.0)
			elif wire.start.y < wire.end.y:
				draw_line(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 2), Vector2(wire.end.x - 16384 + 1, wire.end.y - 16384 + 2), "054A91", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 2, wire.start.y - 16384 + 1), Vector2(wire.start.x - 16384 + 2, wire.end.y - 16384 + 3), "E54B4B", 2.0)
				#draw_line(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 2), Vector2(wire.end.x - 16384 + 1, wire.end.y - 16384 + 2), "054A91", 2.0)
	
	for wire in selectedWire:
		draw_rect(wire, Color(0, 0, 0, 0.5), true)
	
	draw_rect(hoveredWire, Color(0, 0, 0, 0.5), true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	globalPosition = get_global_mouse_position()
	var everyother = 0
	
	if activeWires == true:
		queue_redraw()
	
	"""if grid.startPos != Vector2.ZERO && Input.is_action_pressed("shift") && Time.get_ticks_msec() <= grid.pressTime + 500:
		if Input.is_action_just_released("left_click"):
			printt(hoveredWire, hoveredWire.position.x + 16384 - 3, hoveredWire.position.y + 16384 - 3, hoveredWire.position.x + 16384 - 3 + hoveredWire.size.x, hoveredWire.position.y + 16384 - 3 + hoveredWire.size.y)
			#for wire in allWires:
				#if (hoveredWire.position.x + 16384 - 1 == wire.start.x || hoveredWire.position.x + 16384 - 3 == wire.start.x) && (hoveredWire.position.y + 16384 - 1 == wire.start.y || hoveredWire.position.y + 16384 - 3 == wire.start.y):
					#if (hoveredWire.position.x + 16384 - 1 + hoveredWire.size.x == wire.end.x || hoveredWire.position.x + 16384 - 3 + hoveredWire.size.x == wire.end.x) && (hoveredWire.position.y + 16384 - 1 + hoveredWire.size.y == wire.end.y || hoveredWire.position.y + 16384 - 3 + hoveredWire.size.y == wire.end.y):
						#printt(selectedWire, selectedWire[selectedWire.find(hoveredWire)])
			printt(hoveredWire, selectedWire)
			for wire in selectedWire:
				if hoveredWire == wire:
					printt(hoveredWire, wire, selectedWire, "test")"""
	if grid.startPos != Vector2.ZERO && !Input.is_action_pressed("shift") && Time.get_ticks_msec() > grid.pressTime + 500 && movingWire == []:
		selectedWire.clear()
		print("clearing selected wire")
		queue_redraw()
	# May be useful later idk
	
	for i in range(allWires.size() - 1, -1, -1):
		var wire = allWires[i]

		if grid.startPos == Vector2.ZERO:
			if wire.end.x >= wire.start.x:
				if globalPosition.x + 16384 - 1 >= wire.start.x && globalPosition.x + 16384 - 3 <= wire.end.x && globalPosition.y + 16384 >= wire.start.y + 1 && globalPosition.y + 16384 <= wire.start.y + 3:
					hoveredWire = Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(wire.end.x - wire.start.x + 2, 2))
					queue_redraw()
					break
				else:
					hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
				if wire.start.y >= wire.end.y:
					if globalPosition.y + 16384 <= wire.start.y + 1 && globalPosition.y + 16384 >= wire.end.y + 1 && globalPosition.x + 16384 >= wire.end.x + 1 && globalPosition.x + 16384 <= wire.end.x + 3:
						hoveredWire = Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2))
						queue_redraw()
						break
					else:
						hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
				elif wire.start.y < wire.end.y:
					if globalPosition.y + 16384 >= wire.start.y + 1 && globalPosition.y + 16384 <= wire.end.y + 3 && globalPosition.x + 16384 >= wire.end.x + 1 && globalPosition.x + 16384 <= wire.end.x + 3:
						hoveredWire = Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y + 2))
						queue_redraw()
						break
					else:
						hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
			elif wire.end.x < wire.start.x:
				if globalPosition.x + 16384 - 3 <= wire.start.x && globalPosition.x + 16384 - 1 >= wire.end.x && globalPosition.y + 16384 >= wire.end.y + 1 && globalPosition.y + 16384 <= wire.end.y + 3:
					hoveredWire = Rect2(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 1), Vector2(wire.end.x - wire.start.x - 2, 2))
					queue_redraw()
					break
				else:
					hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
				if wire.start.y >= wire.end.y:
					if globalPosition.y + 16384 <= wire.start.y + 3 && globalPosition.y + 16384 >= wire.end.y + 3 && globalPosition.x + 16384 >= wire.start.x + 1 && globalPosition.x + 16384 <= wire.start.x + 3:
						hoveredWire = Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2))
						queue_redraw()
						break
					else:
						hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
				elif wire.start.y < wire.end.y:
					if globalPosition.y + 16384 >= wire.start.y + 1 && globalPosition.y + 16384 <= wire.end.y + 3 && globalPosition.x + 16384 >= wire.start.x + 1 && globalPosition.x + 16384 <= wire.start.x + 3:
						hoveredWire = Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y))
						queue_redraw()
						break
					else:
						hoveredWire = Rect2(Vector2.ZERO, Vector2.ZERO)
			queue_redraw()
		else:
			if Time.get_ticks_msec() > grid.pressTime + 100:
				printt(wire, hoveredWire.position + Vector2(16384, 16384), hoveredWire.end + Vector2(16384, 16384), hoveredWire.end)
				if isWireSame(wire, {"start": hoveredWire.position + Vector2(16384, 16384), "end": hoveredWire.end + Vector2(16384, 16384)}):
					#printt(hoveredWire, "hoveredWire", wire, "wire")
					if (movingWire.has(allWires[i])):
						movingWire.remove_at(movingWire.find(allWires[i]))
					
					var differenceX = round(globalPosition.x) - grid.startPos.x
					var differenceY = round(globalPosition.y) - grid.startPos.y
					#printt(differenceX, differenceY)
					for j in range(selectedWire.size() - 1, -1, -1):
						print({"start": selectedWire[j].position + Vector2(16384, 16384), "end": selectedWire[j].position + Vector2(16384, 16384) + selectedWire[j].size})
						var index = findWire(allWires, {"start": selectedWire[j].position + Vector2(16384, 16384), "end": selectedWire[j].position + Vector2(16384, 16384) + selectedWire[j].size})
						var selected = allWires[index]
						#var selected = allWires[allWires.find({"start": selectedWire[j].position + Vector2(16384, 16384), "end": selectedWire[j].position + Vector2(16384, 16384) + selectedWire[j].size})]
						printt(selected, selectedWire, differenceX, differenceY, allWires, grid.startPos, globalPosition)
						selected.start.x += differenceX
						selected.end.x += differenceX
						selected.start.y += differenceY
						selected.end.y += differenceY
						selectedWire[j].position.x += differenceX
						selectedWire[j].position.y += differenceY
						allWires[index] = selected
					
					grid.startPos.x += differenceX
					grid.startPos.y += differenceY
					hoveredWire.position.x += differenceX
					hoveredWire.position.y += differenceY
					if (!movingWire.has(allWires[i])):
						movingWire.append(allWires[i])
					print("testing")
					queue_redraw()
				elif ((wire.start.x + 2 <= grid.startPos.x + 16384 && wire.end.x + 2 >= grid.startPos.x + 16384) || (wire.end.x + 2 >= round(globalPosition.x) + 16384 && wire.start.x + 2 <= round(globalPosition.x) + 16384) || (grid.startPos.x + 16384 <= wire.start.x + 2 && round(globalPosition.x) + 16384 >= wire.end.x + 2) || (grid.startPos.x + 16384 >= wire.start.x + 2 && round(globalPosition.x) + 16384 <= wire.start.x + 2)) && movingWire == []:
					if (wire.start.y + 2 >= grid.startPos.y + 16384 && wire.end.y + 2 <= grid.startPos.y + 16384) || (wire.start.y + 2 <= grid.startPos.y + 16384 && wire.end.y + 2 >= grid.startPos.y + 16384) || (wire.end.y + 2 <= round(globalPosition.y) + 16384 && wire.start.y + 2 >= round(globalPosition.y) + 16384) || (grid.startPos.y + 16384 >= wire.start.y + 2 && round(globalPosition.y) + 16384 <= wire.end.y + 2) || (grid.startPos.y + 16384 <= wire.start.y + 2 && round(globalPosition.y) + 16384 >= wire.start.y + 2):
						if wire.end.x >= wire.start.x:
							if wire.start.y == wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(wire.end.x - wire.start.x + 2, 2))):
									selectedWire.append(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(wire.end.x - wire.start.x + 2, 2)))
									queue_redraw()
							elif wire.start.y > wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2))):
									selectedWire.append(Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2)))
									queue_redraw()
							elif wire.start.y < wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y + 2))):
									selectedWire.append(Rect2(Vector2(wire.end.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y + 2)))
									queue_redraw()
						elif wire.end.x < wire.start.x:
							if wire.start.y == wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 1), Vector2(wire.end.x - wire.start.x - 2, 2))):
									selectedWire.append(Rect2(Vector2(wire.start.x - 16384 + 3, wire.end.y - 16384 + 1), Vector2(wire.end.x - wire.start.x - 2, 2)))
									queue_redraw()
							"""elif wire.start.y > wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2))):
									selectedWire.append(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 3), Vector2(2, wire.end.y - wire.start.y - 2)))
									queue_redraw()
							elif wire.start.y < wire.end.y:
								if !selectedWire.has(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y))):
									selectedWire.append(Rect2(Vector2(wire.start.x - 16384 + 1, wire.start.y - 16384 + 1), Vector2(2, wire.end.y - wire.start.y)))
									queue_redraw()"""
							# I'm pretty sure this code is useless
			else:
				if Input.is_action_just_released("left_click"):
					movingWire = []
					everyother += 1
					var dontAppend = false
					if everyother % allWires.size() == 0:
						for selection in selectedWire:
							if hoveredWire == selection && Input.is_action_pressed("shift"):
								printt(selectedWire, "unselecting wire")
								selectedWire.erase(hoveredWire)
								dontAppend = true
								break
							elif hoveredWire != selection && !Input.is_action_pressed("shift"):
								printt(selectedWire, "selecting only this wire")
								selectedWire.clear()
								break
						if hoveredWire == Rect2(Vector2.ZERO, Vector2.ZERO):
							selectedWire.clear()
						else:
							if !dontAppend:
								print(hoveredWire, "hovered wire")
								selectedWire.append(hoveredWire)
						queue_redraw()
	
	if endPoint != Vector2.ZERO && Input.is_action_just_released("left_click"):
		activeWires = false
		if floor(startPoint.x / 32) != floor(endPoint.x / 32) && !allWires.has({"start": startPoint, "end": endPoint}):
			if endPoint.x > startPoint.x:
				allWires.push_back({"start": startPoint, "end": Vector2(endPoint.x, startPoint.y)})
				allWires.push_back({"start": Vector2(endPoint.x, startPoint.y), "end": endPoint})
				undoArray.push_back([{"wire": {"start": startPoint, "end": Vector2(endPoint.x, startPoint.y)}, "type": "newWire"}, {"wire": {"start": Vector2(endPoint.x, startPoint.y), "end": endPoint}, "type": "newWire"}])
			elif startPoint.x > endPoint.x:
				allWires.push_back({"start": startPoint, "end": Vector2(startPoint.x, endPoint.y)})
				allWires.push_back({"start": Vector2(startPoint.x, endPoint.y), "end": endPoint})
				undoArray.push_back([{"wire": {"start": startPoint, "end": Vector2(startPoint.x, endPoint.y)}, "type": "newWire"}, {"wire": {"start": Vector2(startPoint.x, endPoint.y), "end": endPoint}, "type": "newWire"}])
			print(allWires)
			redoArray.clear()
	elif activeWires == false:
		activeWires = false
		startPoint = Vector2.ZERO
		endPoint = Vector2.ZERO
	elif endPoint == Vector2.ZERO && Input.is_action_just_released("left_click"):
		activeWires = false
		if startPoint.x < round(globalPosition.x) + 16384:
			if startPoint.y >= round(globalPosition.y) + 16384:
				endPoint = round(globalPosition) + Vector2(16384 - 3, 16384 - 2)
			else:
				endPoint = round(globalPosition) + Vector2(16384 - 3, 16384 - 4)
		else:
			#For some reason it doesn't need a second case
			endPoint = round(globalPosition) + Vector2(16384 - 1, 16384 - 1)
		if floor(startPoint.x / 32) != floor(endPoint.x / 32) && !allWires.has({"start": startPoint, "end": endPoint}):
			if endPoint.x > startPoint.x:
				allWires.push_back({"start": startPoint, "end": Vector2(endPoint.x, startPoint.y)})
				allWires.push_back({"start": Vector2(endPoint.x, startPoint.y), "end": endPoint})
				undoArray.push_back([{"wire": {"start": startPoint, "end": Vector2(endPoint.x, startPoint.y)}, "type": "newWire"}, {"wire": {"start": Vector2(endPoint.x, startPoint.y), "end": endPoint}, "type": "newWire"}])
			elif startPoint.x > endPoint.x:
				allWires.push_back({"start": startPoint, "end": Vector2(startPoint.x, endPoint.y)})
				allWires.push_back({"start": Vector2(startPoint.x, endPoint.y), "end": endPoint})
				undoArray.push_back([{"wire": {"start": startPoint, "end": Vector2(startPoint.x, endPoint.y)}, "type": "newWire"}, {"wire": {"start": Vector2(startPoint.x, endPoint.y), "end": endPoint}, "type": "newWire"}])
			print(allWires)
			redoArray.clear()
		queue_redraw()
	
	if Input.is_action_just_pressed("delete"):
		#print(selectedWire)
		var undo : Array
		var i = 0
		while i < selectedWire.size():
		#for selected in selectedWire:
			var selected = selectedWire[i]
			for wire in allWires:
				var startx = selected.position.x + 16384
				var starty = selected.position.y + 16384
				var endx = selected.position.x + selected.size.x + 16384
				var endy = selected.position.y + selected.size.y + 16384
				#printt(startx, starty, endx, endy)
				if (wire.start.x == startx + 1 || wire.start.x == startx - 1 || wire.start.x == startx + 3 || wire.start.x == startx - 3) && (wire.end.x == endx + 1 || wire.end.x == endx - 1 || wire.end.x == endx + 3 || wire.end.x == endx - 3):
					if (wire.start.y == starty + 1 || wire.start.y == starty - 1 || wire.start.y == starty + 3 || wire.start.y == starty - 3) && (wire.end.y == endy + 1 || wire.end.y == endy - 1 || wire.end.y == endy + 3 || wire.end.y == endy - 3):
						allWires.remove_at(allWires.find(wire))
						selectedWire.remove_at(selectedWire.find(selected))
						undo.append({"wire": wire, "type": "deleteWire"})
						redoArray.clear()
						i -= 1
						break
			i += 1
		#printt(selectedWire, i)
		undoArray.append(undo)
		print(undoArray)
		queue_redraw()
	if Input.is_action_just_pressed("redo"):
		if redoArray.size() > 0:
			printt("redo", redoArray)
			for redo in redoArray[redoArray.size() - 1]:
				if redo.type == "deleteWire":
					allWires.remove_at(allWires.find(redo.wire))
				if redo.type == "newWire":
					allWires.append(redo.wire)
				if redo.type == "deleteGate":
					grid.changeDic(redo.gate.x, redo.gate.y, "Empty", 0)
			undoArray.append(redoArray[redoArray.size() - 1])
			redoArray.remove_at(redoArray.find(redoArray[redoArray.size() - 1]))
	elif Input.is_action_just_pressed("undo"):
		if undoArray.size() > 0:
			printt("undo", undoArray)
			for undo in undoArray[undoArray.size() - 1]:
				if undo.type == "deleteWire":
					allWires.append(undo.wire)
				elif undo.type == "newWire":
					allWires.remove_at(allWires.find(undo.wire))
				elif undo.type == "deleteGate":
					printt(undo.gate.x, undo.gate.y, undo.gate.cell, undo.gate.rotate)
					grid.changeDic(undo.gate.x, undo.gate.y, undo.gate.cell, undo.gate.rotate)
			redoArray.append(undoArray[undoArray.size() - 1])
			undoArray.remove_at(undoArray.find(undoArray[undoArray.size() - 1]))

func isWireSame(wire: Dictionary, otherWire: Dictionary) -> bool:
	if ((wire.start.x == otherWire.start.x + 1 || wire.start.x == otherWire.start.x - 1 || wire.start.x == otherWire.start.x + 3 || wire.start.x == otherWire.start.x - 3) && (wire.start.y == otherWire.start.y + 1 || wire.start.y == otherWire.start.y - 1 || wire.start.y == otherWire.start.y + 3 || wire.start.y == otherWire.start.y - 3)):
		if ((wire.end.x == otherWire.end.x + 1 || wire.end.x == otherWire.end.x - 1 || wire.end.x == otherWire.end.x + 3 || wire.end.x == otherWire.end.x - 3) && (wire.end.y == otherWire.end.y + 1 || wire.end.y == otherWire.end.y - 1 || wire.end.y == otherWire.end.y + 3 || wire.end.y == otherWire.end.y - 3)):
			return true
	return false

func findWire(array: Array, wire: Dictionary) -> int:
	for i in range(array.size() - 1, -1, -1):
		printt(array[i], wire, i)
		if isWireSame(array[i], wire):
			print(i)
			return i
	print("returned - 1")
	return -1
