class_name Ball extends CharacterBody2D

@onready var ball_sound_effects: AudioStreamPlayer2D = $Audio/BallSoundEffects
@onready var audio: Audio = $Audio
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal hit_brick

var in_motion = false
var paddle: PlayerPaddle = null
var initial_x_spread = 400
const initial_speed = 750
var stage_start_speed
var max_speed
var stage_won = false
var speed_and_score_change = []
var slow_ball = false
var slow_ball_speed = 500
var go_to_right = false

signal stage_started



# speed - print(sqrt(velocity.x ** 2 + velocity.y ** 2))

func _ready() -> void:
	stage_start_speed = GlobalVariables.ball_speed
	max_speed = stage_start_speed
	$Sprite2D.visible = false


func _physics_process(delta: float) -> void:
	if !in_motion: 	# initial ball snap to paddle
		if paddle == null:
			get_paddle()
			if paddle == null:
				return
		var go_to_paddle_position = paddle.position
		if slow_ball:
			if go_to_right:
				go_to_paddle_position.x +=50
			else:
				go_to_paddle_position.x -=50
		go_to_paddle_position.y -= 34
		position = go_to_paddle_position
		$Sprite2D.visible = true
		if Input.is_action_just_pressed("start_game"):	# initial ball jumping off
			if !stage_won:
				stage_started.emit()
				position += Vector2(0, -1)
				var x_velo = randi_range(-initial_x_spread, initial_x_spread)
				var y_velo = sqrt((max_speed ** 2) - (x_velo ** 2))
				velocity.x = x_velo
				velocity.y = -y_velo
				in_motion = true
	else:	# while in movement
		if !slow_ball:
			max_speed = GlobalVariables.ball_speed
		else:
			max_speed = slow_ball_speed
		var collision = move_and_collide(velocity * delta)

		if collision:
			var collider := collision.get_collider()

			if collider is Brick:	# increase speed when hitting a brick
				hit_brick_logic(collider)
				velocity = velocity.bounce(collision.get_normal())
				collider.on_hit()
				
			elif collider is PlayerPaddle:	# change bounce depending on paddle position and speed
				var normal = collision.get_normal()
				var paddle = collider
				
				if normal.y > 0:
					velocity = velocity.bounce(normal)
					velocity = velocity.normalized() * max_speed
				
				else:
					var paddle_width = paddle.get_total_width()

					var relative_x = global_position.x - paddle.global_position.x
					
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
					velocity.x += collider.velocity.x * 0.3
					velocity = velocity.normalized() * max_speed
				ball_sound_effects.play_paddle_hit()
			else:
				velocity = velocity.bounce(collision.get_normal())
				var angle = atan2(velocity.y, velocity.x)

				var min_angle = deg_to_rad(10)  # minimum angle from horizontal

				# Clamp angle away from horizontal
				if abs(sin(angle)) < sin(min_angle):
					angle = sign(angle) * min_angle
				if slow_ball:
					velocity = Vector2(cos(angle), sin(angle)) * slow_ball_speed
				else:
					velocity = Vector2(cos(angle), sin(angle)) * max_speed
				ball_sound_effects.play_wall_hit()
				audio.balance_sounds()
			position += collision.get_normal() * 1.0


func get_paddle(parent = false):
	if parent:
		for sibling in parent.get_children():
			if sibling is PlayerPaddle:
				paddle = sibling
	else:
		for sibling in get_parent().get_children():
			if sibling is PlayerPaddle:
				paddle = sibling

func ball_reset():
	in_motion = false

func hit_brick_logic(collider):
	speed_and_score_change = change_speed(collider)
	
	if GlobalVariables.score_without_speed < randf():
		GlobalVariables.ball_speed += speed_and_score_change[1]
	else:
		print("Speed no added")
	
	GlobalVariables.current_score += speed_and_score_change[0] * GlobalVariables.score_multiplier
	if slow_ball:
		print("Slow ball - Ball max speed: " + str(max_speed) + " Global ball speed: " + str(GlobalVariables.ball_speed))
	else: print("Main ball - Ball max speed: " + str(max_speed) + " Global ball speed: " + str(GlobalVariables.ball_speed))



func change_speed(collider):
	var frame
	if collider.brick_type == null:
		frame = collider.animated_sprite_2d.frame
	else:
		frame = collider.brick_type
	
	var added_gold
	if frame != 4:
		added_gold = GlobalVariables.brick_gold_value[frame] * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier
		GlobalVariables.gold += added_gold
		Signals.gold_gained.emit(added_gold)
		return [GlobalVariables.brick_score_value[frame], GlobalVariables.brick_speed_value[frame]]
	else:
		added_gold = LevelUpVariables.brick3_cracked_multiplier * GlobalVariables.brick_gold_value[frame - 1] * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier
		GlobalVariables.gold += added_gold
		Signals.gold_gained.emit(added_gold)
		return [GlobalVariables.brick_score_value[frame - 1] * LevelUpVariables.brick3_cracked_multiplier, GlobalVariables.brick_speed_value[frame - 1]]


func make_slow_ball():
	slow_ball = true
	set_collision_layer_value(0, false)
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_mask_value(0, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	var shader = Shader.new()
	shader.code = """
        shader_type canvas_item;

        uniform vec4 target_color : source_color;

        void fragment() {
            vec4 tex = texture(TEXTURE, UV);
            COLOR = vec4(target_color.rgb, tex.a);
        }
	"""

	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("target_color", Color("ffe460ff"))
	
	$Sprite2D.material = material
	max_speed = slow_ball_speed
	pass

func animate_destroy():
	var tween: Tween
	tween = create_tween()
	tween.tween_property(self, "scale", scale * 0.001, 0.2)
	await tween.finished
