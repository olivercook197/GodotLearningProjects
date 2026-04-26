extends AnimatedSprite2D

var velocity: Vector2 = Vector2(0, 5)

signal powerup_collected

func _ready() -> void:
	var frame_count = sprite_frames.get_frame_count("powerup_options")
	frame = randi() % frame_count



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPaddle:
		print("Collected")
		print(frame)
		powerup_collected.emit(frame)
		self.queue_free()
	pass # Replace with function body.
