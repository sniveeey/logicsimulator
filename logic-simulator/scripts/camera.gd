extends Camera2D

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false
var zoomAmount = 14
var gridSize = 32
var leftLimit = -16384 + (zoomAmount + 2) * gridSize
var rightLimit = 16384 - (zoomAmount + 2) * gridSize
var topLimit = -16384 + (zoomAmount + 2) * gridSize
var bottomLimit = 16384 - (zoomAmount + 2) * gridSize

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Zoom()
	Pan()

func Zoom():
	if Input.is_action_just_pressed("zoom_in") && zoom.x < 14:
		var mouse_pos = get_global_mouse_position()
		zoomAmount -= 1
		zoom.x = 14.0/zoomAmount
		zoom.y = 14.0/zoomAmount
		var new_mouse_pos = get_global_mouse_position()
		position += mouse_pos - new_mouse_pos
		
	if Input.is_action_just_pressed("zoom_out") && zoom.x > .4:
		zoomAmount += 1
		zoom.x = 14.0/zoomAmount
		zoom.y = 14.0/zoomAmount
	
func Pan():
	if !isDragging && Input.is_action_just_pressed("pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	
	if isDragging && Input.is_action_just_released("pan"):
		isDragging = false
	
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		var testPos = position
		#print(position)
		if position.x < leftLimit:
			position.x = leftLimit
		elif position.x > rightLimit:
			position.x = rightLimit
		elif position.y < topLimit:
			position.y = topLimit
		elif position.y > bottomLimit:
			position.y = bottomLimit
		var newPos = position
		#print(testPos - newPos, " ", moveVector, " ", position)
		moveVector += (testPos - newPos)
		dragStartMousePos -= (testPos - newPos)
		#print(moveVector)
		position = round(dragStartCameraPos - moveVector * 1/zoom.x)
