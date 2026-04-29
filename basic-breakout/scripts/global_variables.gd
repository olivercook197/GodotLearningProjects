extends Node2D

# attributes
const initial_lives := 3
var max_lives
var remaining_lives
var high_score := 0
var current_score := 0
const starting_gold = 50
var gold := 50
const initial_level = 0
var level

# upgrade stats
const initial_brick_gold_value = [1, 1, 1, 1]
var brick_gold_value
const initial_brick_score_speed_value = [1, 2, 5, 10]
var brick_score_value
var brick_speed_value
const initial_ball_speed = 750	#decreases by speed_decrease_on_level_start on first level, so real initial speed is lower
var ball_speed
const initial_paddle_position = Vector2(0, 460)
var paddle_position
const initial_paddle_x_length = 1
const max_paddle_x_length = 4
var paddle_x_length
const initial_interest = 0
var interest
const initial_score_without_speed = 0
var score_without_speed
const initial_speed_decrease_on_level_start = 50
var speed_decrease_on_level_start
const initial_powerup_chance = 5
var powerup_chance
const initial_brick_change_chance = [0, 0, 0, 0]
var brick_change_chance

# gold costs
const initial_inflation : float = 1
var inflation
const initial_inflation_rate = 1.1
var inflation_rate
const initial_gold_costs = [3, 6, 9, 12, 15, 20]	#{VERY_LOW, LOW, MEDIUM, HIGH, VERY_HIGH, EXTREME}
var gold_costs
const initial_rerolls = 1
var max_rerolls

# in-game
var gold_multiplier: int = 1

func high_score_updated(score):
	current_score = score
	if score >= high_score:
		high_score = score

func set_variables():
	max_lives = initial_lives
	remaining_lives = max_lives
	
	gold = starting_gold
	current_score = 0
	level = initial_level

	brick_gold_value = initial_brick_gold_value.duplicate()
	brick_score_value = initial_brick_score_speed_value.duplicate()
	brick_speed_value = initial_brick_score_speed_value.duplicate()
	
	ball_speed = initial_ball_speed
	paddle_position = initial_paddle_position
	paddle_x_length = initial_paddle_x_length
	
	interest = initial_interest
	score_without_speed = initial_score_without_speed
	
	speed_decrease_on_level_start = initial_speed_decrease_on_level_start
	powerup_chance = initial_powerup_chance
	brick_change_chance = initial_brick_change_chance
	
	inflation = initial_inflation
	inflation_rate = initial_inflation_rate
	gold_costs = initial_gold_costs
	max_rerolls = initial_rerolls
	
	
