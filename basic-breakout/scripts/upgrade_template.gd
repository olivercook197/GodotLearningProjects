#When an upgrade target is chosen, changing an attribute to one outside those allowed does nothing

@tool
class_name UpgradeTemplate extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

enum UpgradeTarget {BALL, PADDLE, BRICK, MISC}
enum AttributeChanged  {SPEED_BALL, LENGTH_PADDLE, SCORE_BRICK, GOLD_BRICK, LIFE_MISC}

@export var upgrade_name: String:
	set(value):
		pass

@export var upgrade_target: UpgradeTarget:
	set(value):
		upgrade_target = value

@export var attribute_changed: AttributeChanged:
	set(value):
		attribute_changed = value

@export var number_change: int:
	set(value):
		pass
