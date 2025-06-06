extends TextureRect
var gateOut = false

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if gateOut == true:
		draw_rect(Rect2(Vector2(720, 32), Vector2(160, 896 - 64)), Color(0, 0, 0, 0.75))
	else:
		draw_rect(Rect2(Vector2(816, 32), Vector2(64, 832)), Color(0, 0, 0, 0.75))
