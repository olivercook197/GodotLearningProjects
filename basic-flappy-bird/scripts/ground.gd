class_name Ground extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_variations = sprite.sprite_frames

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var types_of_ground = sprite_variations.get_animation_names()
	var random_sprite = randi_range(0, len(types_of_ground) - 1)
	sprite.play(types_of_ground[random_sprite])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
