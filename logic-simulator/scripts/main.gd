extends Node2D
signal mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

"""func _on_mode_change(newMode: String) -> void:
	if newMode != "":
		Input.set_custom_mouse_cursor(load("res://sprites/" + newMode + ".png"), Input.CURSOR_ARROW, Vector2(16, 16))
	else:
		Input.set_custom_mouse_cursor(null)
	pass"""
