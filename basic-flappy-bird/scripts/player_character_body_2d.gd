extends CharacterBody2D


const JUMP_VELOCITY = -300.0
var is_dead = false
var flap = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && !is_dead:
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("double_flap")
		flap = 1
		#if $AnimatedSprite2D.get_animation() == "flapping":
			#print("Flap")
			#$AnimatedSprite2D.play("double_flap")
			#$AnimatedSprite2D.play("flapping")
		#else:
			#$AnimatedSprite2D.play("flapping")
		#$AnimatedSprite2D/Timer.start()

	move_and_slide()


func _on_timer_timeout() -> void:
	if is_dead != true:
		$AnimatedSprite2D.play("idle")

func player_died():
	is_dead = true
	$AnimatedSprite2D.play("dead")
	velocity.y = JUMP_VELOCITY


func _on_animated_sprite_2d_animation_finished() -> void:
	if flap == 1:
		$AnimatedSprite2D.play("flapping")
		flap -= 1
	else:
		$AnimatedSprite2D.play("idle")
