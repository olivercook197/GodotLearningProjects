extends AnimatedSprite2D

var velocity: Vector2 = Vector2(0, 250)
var value
var move_to_paddle

signal xp_collected

func _ready() -> void:
	var frame_count = sprite_frames.get_frame_count("xp_types")
	frame = randi() % frame_count
	calculate_value()
	scale = Vector2(0.6 + value * 0.15, 0.6 + value * 0.15)

func calculate_value():
	value = 1
	var rand = 1
	
	while rand > 0.5:
		rand = randf()
		if rand > 0.5 and value <= 9:
			value += 1
		else:
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_to_paddle:
		
		var parent = get_parent()

		for child in parent.get_children():
			if child.is_in_group("paddle"):
				var target = child.position
				var to_target = target - position
				var distance = to_target.length()
				
				if distance < 1:
					position += Vector2(1, 1)
					return
				
				var speed = max(distance * 3.0, 600)
				position += to_target.normalized() * speed * delta

	else:
		position += velocity * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPaddle:
		xp_collected.emit(value)
		queue_free()

func go_to_paddle():
	move_to_paddle = true
	pass
