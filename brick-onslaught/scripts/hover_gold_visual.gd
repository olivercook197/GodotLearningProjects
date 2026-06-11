extends Node
class_name HoverGoldVisual

@export var button_path: NodePath	# set in Inspector

@onready var button: BaseButton = get_node_or_null(button_path)
signal hovered
signal stopped_hovering

var cost: int = 0

func _ready():
	assert(button != null, "HoverAnimator: button_path invalid")	# set in Inspector

	_connect_signals()

func _connect_signals():
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if !button.disabled:
		hovered.emit()


func _on_mouse_exited():
	if !button.disabled:
		stopped_hovering.emit()
