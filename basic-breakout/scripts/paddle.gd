class_name PlayerPaddle extends CharacterBody2D

@onready var collision_main: CollisionShape2D = $CollisionMain
@onready var sprite: Sprite2D = $Sprite2D
@onready var paddle_left_side_panel: Sprite2D = $PaddleLeftSidePanel
@onready var paddle_right_side_panel: Sprite2D = $PaddleRightSidePanel

const panel_x_size = 150

const SPEED = 2200.0

var is_flashing := false

var has_panel_hitbox := false

const base_width := 340

var target_x := 0.0
var is_adjusting_position := false


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

func paddle_size():
	var current_base_width = GlobalVariables.paddle_x_length * base_width
	collision_main.shape.size.x = current_base_width
	sprite.scale.x = GlobalVariables.paddle_x_length
	print(current_base_width)
	
	move_panels_to_edge(current_base_width)


func move_panels_to_edge(paddle_size):
	var self_size = panel_x_size
	
	paddle_right_side_panel.position.x = paddle_size / 2 + self_size / 2
	
	paddle_left_side_panel.position.x = -(paddle_size / 2 + self_size / 2)
	
	paddle_left_side_panel.visible = false
	paddle_right_side_panel.visible = false

func enable_side_panels():
	is_flashing = false
	
	if has_panel_hitbox:
		return
	
	var old_width = collision_main.shape.size.x
	var new_width = old_width + (2 * panel_x_size)
	
	clamp_paddle_to_screen(new_width)
	
	collision_main.shape.size.x = new_width
	has_panel_hitbox = true
	
	paddle_left_side_panel.visible = true
	paddle_right_side_panel.visible = true
	
	paddle_left_side_panel.modulate.a = 1.0
	paddle_right_side_panel.modulate.a = 1.0

	
func disable_side_panels():
	await flash_then_disable()

func flash_then_disable():
	is_flashing = true
	var total_time := 5.0
	var elapsed := 0.0
	
	while elapsed < total_time:
		if not is_flashing:
			return
		# Flash gets faster over time
		var t = elapsed / total_time
		var interval = lerp(0.4, 0.05, t) # slow → fast
		
		var visible_state = paddle_left_side_panel.modulate.a > 0.5
		var new_alpha = 0.2 if visible_state else 1.0

		paddle_left_side_panel.modulate.a = new_alpha
		paddle_right_side_panel.modulate.a = new_alpha
	
		# toggle visibility
		paddle_left_side_panel.visible = !paddle_left_side_panel.visible
		paddle_right_side_panel.visible = paddle_left_side_panel.visible
		
		await get_tree().create_timer(interval).timeout
		
		elapsed += interval
	
	# ensure visible before final removal
	paddle_left_side_panel.visible = true
	paddle_right_side_panel.visible = true
	
	# disable
	collision_main.shape.size.x -= 2 * panel_x_size
	has_panel_hitbox = false
	
	paddle_left_side_panel.visible = false
	paddle_right_side_panel.visible = false
	

func remove_panel_hitbox():
	if has_panel_hitbox:
		collision_main.shape.size.x -= 2 * panel_x_size
		has_panel_hitbox = false

func get_total_width():
	var width = collision_main.shape.size.x
	if has_panel_hitbox:
		width += panel_x_size * 2
	return width

func clamp_paddle_to_screen(new_width: float):
	var screen_width = get_viewport_rect().size.x
	
	var half = new_width / 2
	var clamped_x
	if global_position.x >= 0:
		clamped_x = clamp(global_position.x, half, screen_width - half)
	else:
		clamped_x = clamp(global_position.x, half - screen_width, half)
	
	global_position.x = clamped_x
