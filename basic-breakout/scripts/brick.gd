class_name Brick extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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
		self.visible = false
		collision_shape_2d.disabled = true
		self.queue_free()
		
		if frame == 2:
			if randf() * 100 < (GlobalVariables.powerup_chance * 20):
				destroyed.emit(self.position, true)
			else:
				destroyed.emit(self.position, false)
		else:
			if randf() * 100 < GlobalVariables.powerup_chance:
				destroyed.emit(self.position, true)
			else:
				destroyed.emit(self.position, false)
		destroyed.emit(self.position)
