class_name PlayerPaddle extends CharacterBody2D


const SPEED = 2200.0

#var player_colliding = false


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2(0, 0)
	else:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		#move_and_slide()
		pass

#func _player_colliding():
#	player_colliding = true
