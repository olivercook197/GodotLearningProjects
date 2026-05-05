extends AnimatedSprite2D

var velocity: Vector2 = Vector2(0, 250)
var value

signal xp_collected

func _ready() -> void:
	var frame_count = sprite_frames.get_frame_count("xp_types")
	frame = randi() % frame_count
	calculate_value()
	print(value)

func calculate_value():
	value = 1
	var rand = 1
	
	while rand > 0.5:
		rand = randf()
		if rand > 0.5 and value <= 10:
			value += 1
		else:
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPaddle:
		print("Collected")
		print(frame)
		xp_collected.emit(frame)
		self.queue_free()
	pass # Replace with function body.
