extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animations = sprite_frames.get_animation_names()
	
	if animations.size() == 0:
		return
	var random_anim = animations[randi() % animations.size()]
	play(random_anim)
