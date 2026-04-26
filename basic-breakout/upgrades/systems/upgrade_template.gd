#@tool
#class_name UpgradeTemplate extends Resource
#
#enum UpgradeTarget {BALL, PADDLE, BRICK, MISC}
#enum AttributeChanged  {SPEED_BALL, LENGTH_PADDLE, Y_POSITION_PADDLE, SCORE_BRICK, GOLD_BRICK, LIFE_MISC}
#
#@export var upgrade_name: String:
	#set(value):
		#pass
#
#@export var upgrade_target: UpgradeTarget = UpgradeTarget.BALL
#
#
#@export var attribute_changed: AttributeChanged:
	#set(value):
		#attribute_changed = value
#
#@export var number_change: int:
	#set(value):
		#number_change = value
#
#@export var texture: Array[CompressedTexture2D] = []:
	#set(value):
		#texture = value

extends Resource
class_name UpgradeTemplate

enum UpgradeTarget {BALL, PADDLE, BRICK, MISC}
enum AttributeChanged {
	SPEED_BALL, LENGTH_PADDLE, Y_POSITION_PADDLE, SCORE_BRICK, GOLD_BRICK, LIFE_MISC, 
	INTEREST_MISC, SCORE_WITHOUT_SPEED_MISC, GAIN_LIFE_MISC
	}
enum GoldCost {VERY_LOW, LOW, MEDIUM, HIGH, VERY_HIGH, EXTREME}
enum BrickAffected {ZERO, ONE, TWO, THREE, FOUR, NONE}

@export var upgrade_name: String
@export var upgrade_desc: String
@export var upgrade_target: UpgradeTarget = UpgradeTarget.BALL
@export var attribute_changed: AttributeChanged = AttributeChanged.SPEED_BALL
@export var brick_affected: BrickAffected = BrickAffected.NONE
@export var number_change: float = 0.0
@export var percentage: bool = false
@export var textures: Array[Texture2D] = []
@export var gold_cost: GoldCost = GoldCost.VERY_LOW
