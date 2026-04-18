extends CharacterBody2D


const JUMP_VELOCITY = -107.0
var is_dead = false
var flap = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 0.41 * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && !is_dead:
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("double_flap")
		flap = 1
	move_and_slide()


func _on_timer_timeout() -> void:
	if is_dead != true:
		$AnimatedSprite2D.play("idle")

func player_died(name):
	print(name)
	is_dead = true
	$AnimatedSprite2D.play("dead")
	velocity.y = JUMP_VELOCITY


func _on_animated_sprite_2d_animation_finished() -> void:
	if flap == 1:
		$AnimatedSprite2D.play("flapping")
		flap -= 1
	else:
		$AnimatedSprite2D.play("idle")
