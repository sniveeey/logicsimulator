extends TextureButton
@onready var popOutHandler: TextureRect = $".."
var group = "group"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var buttonArray = get_parent().get_children()
	for i in buttonArray:
		if i.group == "gate" || i.group == "group":
			if popOutHandler.gateOut == false:
				i.position.x -= 96
			else:
				i.position.x += 96
	popOutHandler.gateOut = !popOutHandler.gateOut
