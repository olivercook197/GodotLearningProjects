class_name Ball extends CharacterBody2D

signal hit_brick

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var in_motion = false
var paddle = PlayerPaddle
var initial_x_spread = 600
const initial_speed = 750
var max_speed = initial_speed
var level_won = false



# speed - print(sqrt(velocity.x ** 2 + velocity.y ** 2))

func _ready() -> void:
	$Sprite2D.visible = false

func _physics_process(delta: float) -> void:
	if !in_motion: 	# initial ball snap to paddle
		var go_to_paddle_position = paddle.position
		go_to_paddle_position.y -= 32
		position = go_to_paddle_position
		$Sprite2D.visible = true
		if Input.is_action_just_pressed("ui_accept"):	# initial ball jumping off
			if !level_won:
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
				
				max_speed += change_speed(collider)
				if collider is Brick:
					collider.on_hit()
				velocity = velocity.bounce(collision.get_normal())
			elif collider is PlayerPaddle:	# change bounce depending on paddle position and speed
				var paddle_width = collider.get_node("CollisionShape2D").shape.size.x
				var relative_x = position.x - collider.position.x
				
				# Normalize hit position to range [-1, 1]
				var normalized = relative_x / (paddle_width / 2)
				normalized = clamp(normalized, -1.0, 1.0)

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
	if collider.animated_sprite_2d.frame == 0:
		GlobalVariables.gold += GlobalVariables.brick_gold_value[0]
		return GlobalVariables.brick_score_value[0]
	elif collider.animated_sprite_2d.frame == 1:
		GlobalVariables.gold += GlobalVariables.brick_gold_value[0]
		return GlobalVariables.brick_score_value[1]
	elif collider.animated_sprite_2d.frame == 2:
		GlobalVariables.gold += GlobalVariables.brick_gold_value[0]
		return GlobalVariables.brick_score_value[2]
	elif collider.animated_sprite_2d.frame == 3:
		GlobalVariables.gold += GlobalVariables.brick_gold_value[0]
		return GlobalVariables.brick_score_value[3]
	elif collider.animated_sprite_2d.frame == 4:
		GlobalVariables.gold += GlobalVariables.brick_gold_value[0]
		return GlobalVariables.brick_score_value[4]
