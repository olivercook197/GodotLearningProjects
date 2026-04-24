extends Node2D

# attributes
var remaining_lives := 3
var high_score := 0
var current_score := 0
var gold := 0

# upgrade stats
const initial_brick_gold_value = [1, 1, 1, 1, 1]
var brick_gold_value
const initial_brick_score_value = [1, 2, 5, 10, 20]
var brick_score_value
const initial_ball_speed = 0
var ball_speed
const initial_paddle_position = Vector2(0, 460)
var paddle_position
const initial_paddle_x_length = 1
var paddle_x_length

# gold costs
const initial_inflation : float = 1
var inflation
const initial_inflation_rate = 1.2
var inflation_rate
const initial_gold_costs = [5, 10, 15, 20, 25, 35]	#{VERY_LOW, LOW, MEDIUM, HIGH, VERY_HIGH, EXTREME}
var gold_costs

func high_score_updated(score):
	current_score = score
	if score >= high_score:
		high_score = score

func set_variables():
	gold = 0
	current_score = 0
	brick_gold_value = initial_brick_gold_value
	brick_score_value = initial_brick_score_value
	ball_speed = initial_ball_speed
	paddle_position = initial_paddle_position
	paddle_x_length = initial_paddle_x_length
	
	
	inflation = initial_inflation
	inflation_rate = initial_inflation_rate
	gold_costs = initial_gold_costs
	
	
