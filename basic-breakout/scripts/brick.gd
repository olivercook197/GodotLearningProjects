class_name Brick extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var brick_sound_effects: AudioStreamPlayer2D = $BrickSoundEffects
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

signal hit
signal destroyed

var brick_type

func choose_frame(sprite):
	animated_sprite_2d.animation = "default"
	animated_sprite_2d.frame = sprite

func on_hit():
	#print(animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation))
	hit.emit(self)
	var frame = animated_sprite_2d.frame
	#if animated_sprite_2d.frame == animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation) - 2:
	if frame == 3:
		animated_sprite_2d.frame += 1
	else:
		var powerup = false
		var extra_xp = false
		self.visible = false
		collision_shape_2d.disabled = true
		self.queue_free()
		if frame == 0:
			if randf() < GlobalVariables.increase_score_multiplier_chance:
				print("Score multiplier increased")
				GlobalVariables.score_multiplier += 0.01
				if LevelUpVariables.brick0_increases_gold_multiplier:
					GlobalVariables.global_gold_multiplier += 0.01
		if frame == 1:
			if randf() < GlobalVariables.extra_xp_chance:
				extra_xp = true
		if frame == 2:
			if randf() < (GlobalVariables.powerup_chance * GlobalVariables.extra_powerup_chance):
				powerup = true
		else:
			if randf() < GlobalVariables.powerup_chance:
				powerup = true
		destroyed.emit(self.position, powerup, extra_xp)
		Signals.brick_destroyed.emit()

func play_destruction_animation():
	brick_type = animated_sprite_2d.frame
	
	var heat_tween = create_tween()

	heat_tween.tween_property(
		$AnimatedSprite2D.material,
		"shader_parameter/heat",
		1.0,
		1.5
	)
	
	var shake_tween = create_tween()
	var amplitude := 0.05
	var duration := 0.38

	for i in range(15):
		shake_tween.tween_property(
			self,
			"rotation",
			amplitude * (-1 if i % 2 else 1) * (1 + i * 0.05),
			duration
		)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

		duration *= 0.75
	
	await shake_tween.finished
	var righten_tween = create_tween()
	righten_tween.tween_property(
			self,
			"rotation",
			0,
			0.001
		)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	$AnimatedSprite2D.material = null
	
	animated_sprite_2d.animation = "destroyed"
	if brick_type == 0:
		animated_sprite_2d.modulate = Color("#FDFFD8")
	elif brick_type == 1:
		animated_sprite_2d.modulate = Color("#C43AFF")
	elif brick_type == 2:
		animated_sprite_2d.modulate = Color("#FF8819")
	elif brick_type == 3:
		animated_sprite_2d.modulate = Color("#D30003")
	elif brick_type == 4:
		animated_sprite_2d.modulate = Color("#D30003")
	animated_sprite_2d_2.visible = true
	animated_sprite_2d_2.modulate.a = 0.5
	animated_sprite_2d_2.play()
	animated_sprite_2d.play()
	
	
	pass
