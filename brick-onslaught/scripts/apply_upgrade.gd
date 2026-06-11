extends Node
var data: UpgradeTemplate

func apply_upgrade(upgrade_data: UpgradeTemplate, gold_cost):
	GlobalVariables.gold -= gold_cost
	data = upgrade_data
	if data.attribute_changed == 0:
		change_speed_ball()
	elif data.attribute_changed == 1:
		change_length_paddle()
	elif data.attribute_changed == 2:
		change_y_position_paddle()
	elif data.attribute_changed == 3:
		change_brick_score()
	elif data.attribute_changed == 4:
		change_brick_gold()
	elif data.attribute_changed == 5:
		gain_extra_life()
	elif data.attribute_changed == 6:
		change_interest()
	elif data.attribute_changed == 7:
		change_score_without_speed()
	elif data.attribute_changed == 8:
		gain_life()
	elif data.attribute_changed == 9:
		change_powerup_chance()
	elif data.attribute_changed == 10:
		change_paddle_speed()
	elif data.attribute_changed == 11:
		change_xp_gain()
	elif data.attribute_changed == 12:
		change_laser_threshold()

func change_speed_ball():
	if data.percentage:
		GlobalVariables.ball_speed += int(GlobalVariables.ball_speed * data.number_change * 0.01) - 1
	else:
		GlobalVariables.ball_speed += int(data.number_change)

func change_length_paddle():
	if data.percentage:
		GlobalVariables.paddle_x_length += GlobalVariables.paddle_x_length * (data.number_change / 100)
	else:
		GlobalVariables.paddle_x_length += data.number_change
	if GlobalVariables.max_paddle_x_length < GlobalVariables.paddle_x_length or GlobalVariables.paddle_x_length + 0.25 > GlobalVariables.max_paddle_x_length:
		GlobalVariables.paddle_x_length = GlobalVariables.max_paddle_x_length
	
func change_y_position_paddle():
	GlobalVariables.paddle_position.y += data.number_change

func change_brick_score():
	if data.percentage:
		GlobalVariables.brick_score_value[data.brick_affected] += int(GlobalVariables.brick_score_value[data.brick_affected] * (data.number_change / 100))
	else:
		GlobalVariables.brick_score_value[data.brick_affected] += int(data.number_change)

func change_brick_gold():
	if data.percentage:
		GlobalVariables.brick_gold_value[data.brick_affected] += int(GlobalVariables.brick_gold_value[data.brick_affected] * (data.number_change / 100))
	else:
		GlobalVariables.brick_gold_value[data.brick_affected] += int(data.number_change)

func gain_extra_life():
	GlobalVariables.max_lives += int(data.number_change)
	GlobalVariables.remaining_lives += int(data.number_change)

func change_interest():
	GlobalVariables.interest += int(data.number_change)

func change_score_without_speed():
	GlobalVariables.score_without_speed += data.number_change

func gain_life():
	if GlobalVariables.remaining_lives < GlobalVariables.max_lives:
		GlobalVariables.remaining_lives += int(data.number_change)

func change_powerup_chance():
	GlobalVariables.powerup_chance += data.number_change

func change_paddle_speed():
	GlobalVariables.paddle_speed += data.number_change

func change_xp_gain():
	GlobalVariables.bonus_xp_percent += data.number_change

func change_laser_threshold():
	GlobalVariables.laser_threshold += data.number_change
