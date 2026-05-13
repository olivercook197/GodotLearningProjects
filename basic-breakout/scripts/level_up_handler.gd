extends Node
class_name LevelUpHandler

@export var hover_animator_path: NodePath
@onready var hover: HoverAnimator = get_node_or_null(hover_animator_path)


signal level_up_chosen

func _ready():
	if hover == null:
		push_error("UpgradeHandler: HoverAnimator not found")
		return
	hover.pressed.connect(_on_pressed)
	hover.confirmed.connect(_on_confirmed)

func _on_pressed():
	hover.accept_press()

func _on_confirmed(button):
	
	# wait so release animation plays
	await get_tree().process_frame
	level_up_chosen.emit()
