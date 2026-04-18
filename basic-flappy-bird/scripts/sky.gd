class_name SkyBackground extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_variations = sprite.sprite_frames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var types_of_sky = sprite_variations.get_animation_names()
	var random_sprite = randi_range(0, len(types_of_sky) - 1)
	sprite.play(types_of_sky[random_sprite])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x < -48:
		position.x = 79
