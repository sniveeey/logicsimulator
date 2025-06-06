extends TextureButton
@onready var popOutHandler: TextureRect = $".."
@onready var game = get_parent().get_parent().get_parent() # This is the only way I could think of doing this
var group = "gate"
var mode = ""

func _ready() -> void:
	game.connect("mode", modeChange)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if mode == "xnor_gate":
		game.mode.emit("")
	else:
		game.mode.emit("xnor_gate")

func modeChange(newMode: String) -> void:
	mode = newMode
