extends Resource
class_name UpgradeTemplate

enum UpgradeTarget {BALL, PADDLE, BRICK, MISC}
enum AttributeChanged {
	SPEED_BALL, LENGTH_PADDLE, Y_POSITION_PADDLE, SCORE_BRICK, GOLD_BRICK, LIFE_MISC, 
	INTEREST_MISC, SCORE_WITHOUT_SPEED_MISC, GAIN_LIFE_MISC, POWERUP_CHANCE, SPEED_PADDLE, XP_GAIN_MISC,
	LASER_THRESHOLD_MISC
	}	# when adding a new attribute, add functionality in apply_upgrade.gd
	# if there are requirements, add them in remove_upgrades(upgrades: Array) in shop.gd
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
