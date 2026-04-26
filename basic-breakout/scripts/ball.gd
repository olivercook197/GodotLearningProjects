class_name Ball extends CharacterBody2D

signal hit_brick

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var in_motion = false
var paddle = PlayerPaddle
var initial_x_spread = 400
const initial_speed = 750
var level_start_speed
var max_speed
var level_won = false
var speed_change = 0

signal level_started


# speed - print(sqrt(velocity.x ** 2 + velocity.y ** 2))

func _ready() -> void:
	if GlobalVariables.ball_speed != 0:
		level_start_speed = GlobalVariables.ball_speed - GlobalVariables.speed_decrease_on_level_start
	else:
		level_start_speed = initial_speed
	max_speed = level_start_speed
	$Sprite2D.visible = false

func _physics_process(delta: float) -> void:
	if !in_motion: 	# initial ball snap to paddle
		var go_to_paddle_position = paddle.position
		go_to_paddle_position.y -= 32
		position = go_to_paddle_position
		$Sprite2D.visible = true
		if Input.is_action_just_pressed("start_game"):	# initial ball jumping off
			if !level_won:
				level_started.emit()
				position += Vector2(0, -1)
				var x_velo = randi_range(-initial_x_spread, initial_x_spread)
				var y_velo = sqrt((max_speed ** 2) - (x_velo ** 2))
				velocity.x = x_velo
				velocity.y = -y_velo
				in_motion = true
	else:	# while in movement
		var collision = move_and_collide(velocity * delta)

		if collision:
			var collider := collision.get_collider()

			if collider is Brick:	# increase speed when hitting a brick
				
				speed_change = change_speed(collider)
				if GlobalVariables.score_without_speed < randf() * 100:
					max_speed += speed_change[1]
				else:
					print("Speed no added")
				GlobalVariables.ball_speed = max_speed
				GlobalVariables.current_score += speed_change[0]
				if collider is Brick:
					collider.on_hit()
				velocity = velocity.bounce(collision.get_normal())
				print(GlobalVariables.ball_speed)
			elif collider is PlayerPaddle:	# change bounce depending on paddle position and speed
				var paddle_width = collider.get_node("CollisionShape2D").shape.size.x
				var relative_x = position.x - collider.position.x
				var effective_width = min(paddle_width, 300.0)
				# Normalize hit position to range [-1, 1]
				var normalized = relative_x / (effective_width / 2)
				normalized = clamp(normalized, -1.0, 1.0)
				
				normalized = sign(normalized) * pow(abs(normalized), 1.5)
				# Max bounce angle (in degrees)
				var max_angle = deg_to_rad(60)

				# Calculate bounce angle
				var angle = normalized * max_angle

				# Set velocity based on angle
				velocity.x = sin(angle) * max_speed
				velocity.y = -cos(angle) * max_speed
				velocity.x += collider.velocity.x * 0.5
				velocity = velocity.normalized() * max_speed
			else:
				velocity = velocity.bounce(collision.get_normal())
				var angle = atan2(velocity.y, velocity.x)

				var min_angle = deg_to_rad(10)  # minimum angle from horizontal

				# Clamp angle away from horizontal
				if abs(sin(angle)) < sin(min_angle):
					angle = sign(angle) * min_angle

				velocity = Vector2(cos(angle), sin(angle)) * max_speed
			position += collision.get_normal() * max(2, velocity.length() * 0.01)


func get_paddle():
	for sibling in get_parent().get_children():
		if sibling is PlayerPaddle:
			paddle = sibling

func ball_reset():
	in_motion = false

func change_speed(collider):
	var frame = collider.animated_sprite_2d.frame
	
	
	GlobalVariables.gold += GlobalVariables.brick_gold_value[frame] * GlobalVariables.gold_multiplier
	return [GlobalVariables.brick_score_value[frame], GlobalVariables.brick_speed_value[frame]]
	
