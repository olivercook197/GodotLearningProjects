extends Node
var data: UpgradeTemplate

func apply_upgrade(upgrade_data: UpgradeTemplate):
	data = upgrade_data
	if data.attribute_changed == 0:
		change_speed_ball()
	elif data.attribute_changed == 1:
		change_length_paddle()
	elif data.attribute_changed == 2:
		change_y_position_paddle()
	
	pass

func change_speed_ball():
	if data.percentage:
		GlobalVariables.ball_speed += GlobalVariables.ball_speed * (data.number_change / 100)
	else:
		GlobalVariables.ball_speed += data.number_change

func change_length_paddle():
	if data.percentage:
		GlobalVariables.paddle_x_length += GlobalVariables.paddle_x_length * (data.number_change / 100)
		print(GlobalVariables.paddle_x_length)
	else:
		GlobalVariables.paddle_x_length += data.number_change

func change_y_position_paddle():
	GlobalVariables.paddle_position.y += data.number_change
