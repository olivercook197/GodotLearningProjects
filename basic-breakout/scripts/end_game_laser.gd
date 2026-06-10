extends CharacterBody2D

@onready var end_game_laser_1: AnimatedSprite2D = $Node2D/ColorRect/EndGameLaser1
@onready var end_game_laser_2: AnimatedSprite2D = $Node2D/ColorRect/EndGameLaser2
@onready var end_game_laser_3: AnimatedSprite2D = $Node2D/ColorRect/EndGameLaser3
@onready var end_game_laser_4: AnimatedSprite2D = $Node2D/ColorRect/EndGameLaser4
@onready var sprite_2d_top: Sprite2D = $Node2D/ColorRect/Sprite2DTop
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d_top: CollisionShape2D = $CollisionShape2DTop
@onready var color_rect: ColorRect = $Node2D/ColorRect
@onready var laser_sound_effects: AudioStreamPlayer2D = $Audio/LaserSoundEffects


var moving
var initial_y
var initial_x
var max_x = 0
var current_brick: Brick = null
var locked_to_bricks := false
var bricks_above := 0
var blocking_brick: Brick = null
var hold_y = false
var target_brick
var target_y := 0.0
var started_moving = false
var stopping := false

func _ready() -> void:
	target_y = position.y 
	initial_x = position.x
	initial_y = position.y
	sprite_2d_top.visible = false
	position.y += 2000
	area_2d.monitoring = true
	if LevelUpVariables.laser_burns_hotter:
		scale.x = 1.2
	start_animation()






func start_animation():
	laser_sound_effects.play_laser_active()
	end_game_laser_1.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_2.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_3.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_4.play()
	await get_tree().create_timer(0.3).timeout
	sprite_2d_top.visible = true
	moving = true
	


func _process(delta: float) -> void:
	var collision
	if moving:
		position.x += (140 + GlobalVariables.ball_speed * 0.01) * delta
		
	if stopping:
		color_rect.size.y -= 1400 * delta
		
		if color_rect.size.y <= 1:
			queue_free()
		collision = move_and_collide(Vector2(0, -500) * delta)
	else:
		collision = move_and_collide(Vector2(0, -1500) * delta)
	
	

	var lowest := get_lowest_brick()
	if collision:
		if !started_moving:
			moving = true
			started_moving = true
		if lowest == collision.get_collider():
			sprite_2d_top.visible = true
			var collider = collision.get_collider()
			if collider.script == Brick:
				collider.play_destruction_animation()
				target_y = collider.position.y + 800
		elif lowest != null and lowest.position.y + 800 > position.y:
			position.y = lowest.position.y + 800
			target_y = lowest.position.y + 800
	else:
		if lowest != null and position.y > lowest.position.y:
			target_y = lowest.position.y + 800
	
	position.y = move_toward(
	position.y,
	target_y,
	0.1 * delta
	)
	
	if max_x + initial_x <= position.x and !stopping: 
		moving = false 
		stopping = true
		laser_sound_effects.stop_audio()


func get_lowest_brick() -> Brick:
	var lowest: Brick = null
	for body in area_2d.get_overlapping_bodies():
		if body is Brick:
			if lowest == null or body.global_position.y > lowest.global_position.y:
				lowest = body
	
	return lowest
