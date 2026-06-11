extends Node2D

# attributes
const initial_lives := 3
var max_lives
var remaining_lives
var high_score: int = 0
var current_score: float
const starting_gold = 30
var gold: float = 50
const initial_stage = 0
var stage
var xp_level_cap : int
var xp_level : int
var xp : float
var levels_gained: int

var score_multiplier: float

# upgrade stats
const initial_brick_gold_value = [1, 1, 1, 1]
var brick_gold_value
const initial_brick_score_speed_value = [1, 2, 5, 10]
var brick_score_value
var brick_speed_value
const initial_ball_speed = 750	#decreases by speed_decrease_on_stage_start on first stage, so real initial speed is lower
var ball_speed
const initial_paddle_position = Vector2(0, 460)
var paddle_position
const initial_paddle_x_length = 1
const max_paddle_x_length = 4
var paddle_x_length
var initial_paddle_speed = 100
var paddle_speed: int
const initial_interest = 0
var interest
const initial_score_without_speed = 0
var score_without_speed
const initial_speed_decrease_on_stage_start = 50
var speed_decrease_on_stage_start
const initial_powerup_chance = 0.05
var powerup_chance
const initial_extra_powerup_chance = 2
var extra_powerup_chance
const initial_brick_change_chance = [float(0.0), float(0.0), float(0.0), float(0.0)]
var brick_change_chance
const initial_laser_threshold = 8
var laser_threshold

# unique brick stats
var increase_score_multiplier_chance: float
var extra_xp_chance : float
var bonus_xp_percent : float

# misc
const initial_level_up_options = 3
var level_up_options: int
var global_gold_multiplier: float = 1

# gold costs
const initial_inflation : float = 1
var inflation
const initial_inflation_rate = 0.1
var inflation_rate
const initial_gold_costs = [3, 6, 9, 12, 15, 20]	#{VERY_LOW, LOW, MEDIUM, HIGH, VERY_HIGH, EXTREME}
var gold_costs
const initial_rerolls = 1
var max_rerolls

# in-game
var local_gold_multiplier: int = 1

# enum used as requirements for levelups
enum RequirementsLevelUpStats {
	MAX_LIVES,
	GOLD,
	STAGE,
	XP_LEVEL,
	
	BRICK_GOLD_VALUE,
	BRICK_SCORE_VALUE,
	
	BALL_SPEED,
	PADDLE_POSITION,
	PADDLE_SPEED,
	PADDLE_X_LENGTH,
	
	SCORE_WITHOUT_SPEED,
	SPEED_DECREASE_ON_STAGE_START,
	POWERUP_CHANCE,
	BRICK_CHANGE_CHANCE,
	
	BONUS_XP_PERCENT,
	LEVEL_UP_OPTIONS,
	
	INFLATION,
	INFLATION_RATE
}

var bonus_xp = 0

func high_score_updated(score):
	current_score = score
	if score >= high_score:
		high_score = score

func set_variables():
	xp_level_cap = 50
	xp_level = 1
	xp = 0
	levels_gained = 0
	extra_xp_chance = 0.2
	bonus_xp_percent = 0
	increase_score_multiplier_chance = 0.2
	
	score_multiplier = 1
	global_gold_multiplier = 1
	max_lives = initial_lives
	remaining_lives = max_lives
	
	gold = starting_gold
	current_score = 0
	stage = initial_stage

	brick_gold_value = initial_brick_gold_value.duplicate()
	brick_score_value = initial_brick_score_speed_value.duplicate()
	brick_speed_value = initial_brick_score_speed_value.duplicate()
	
	laser_threshold = initial_laser_threshold
	
	ball_speed = initial_ball_speed
	paddle_position = initial_paddle_position
	paddle_x_length = initial_paddle_x_length
	
	interest = initial_interest
	score_without_speed = initial_score_without_speed
	
	speed_decrease_on_stage_start = initial_speed_decrease_on_stage_start
	powerup_chance = initial_powerup_chance
	extra_powerup_chance = initial_extra_powerup_chance
	brick_change_chance = initial_brick_change_chance.duplicate()
	
	paddle_speed = initial_paddle_speed
	
	inflation = initial_inflation
	inflation_rate = initial_inflation_rate
	gold_costs = initial_gold_costs
	max_rerolls = initial_rerolls
	
	level_up_options = initial_level_up_options
	
	
