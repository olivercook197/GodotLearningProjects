class_name Brick extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var brick_sound_effects: AudioStreamPlayer2D = $BrickSoundEffects

signal hit
signal destroyed

func choose_frame(sprite):
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
