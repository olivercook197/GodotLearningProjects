extends Node
class_name UpgradeHandler

@export var hover_animator_path: NodePath
@onready var hover: HoverAnimator = get_node_or_null(hover_animator_path)

@export var cost: int = 0

signal upgrade_bought
signal upgrade_clicked_too_expensive

var data: UpgradeTemplate

func _ready():
	if hover == null:
		push_error("UpgradeHandler: HoverAnimator not found")
		return
	hover.pressed.connect(_on_pressed)
	hover.confirmed.connect(_on_confirmed)

func _on_pressed():
	if cost > GlobalVariables.gold:
		hover.reject_press()
		upgrade_clicked_too_expensive.emit()
		return
	elif data.attribute_changed == 8 and GlobalVariables.remaining_lives == GlobalVariables.max_lives:
		hover.reject_press()
		return
	
	hover.accept_press()

func _on_confirmed(button):
	GlobalVariables.gold -= cost
	
	# wait one frame (or small delay) so release animation plays
	await get_tree().process_frame
	if data.attribute_changed != 8:
		hover.disable_button()
	upgrade_bought.emit()
