class_name Brick extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

signal hit
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_frame(sprite):
	animated_sprite_2d.frame = sprite

func on_hit():
	#print(animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation))
	hit.emit(self)
	if animated_sprite_2d.frame == animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation) - 2:
		animated_sprite_2d.frame += 1
	else:
		self.visible = false
		collision_shape_2d.disabled = true
		self.queue_free()
		destroyed.emit()
