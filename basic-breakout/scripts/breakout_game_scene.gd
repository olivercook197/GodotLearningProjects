extends Node2D

const BOUNDARY = preload("uid://d772en1051bk")
const PADDLE = preload("uid://tbgughlh81ae")
const BALL = preload("uid://cuaeu3do68vtt")
const BRICK = preload("uid://yuqauunfvg2t")
const LIVES = preload("uid://v36pc1cur2mv")
const POWERUP = preload("uid://cntm4nhm84n3n")
const TEN_SECOND_TIMER = preload("uid://8ik8vqkn7hep")

@onready var world_border: Area2D = $WorldBorder
@onready var game_over_panel: Panel = $CarryThrough/GameOver/Panel
@onready var level_win_panel: PanelContainer = $CarryThrough/LevelWin/PanelContainer
@onready var score_label: PanelContainer = $CarryThrough/ScorePanelContainer
@onready var game_over_label: Label = $CarryThrough/GameOver/Panel/GameOverLabel
@onready var carry_through: Node2D = $CarryThrough
@onready var gold_label: Label = $CarryThrough/GoldPanelContainer/GoldLabel
@onready var start_game_label: Label = $CarryThrough/StartGameLabel
@onready var life_manager: Node = $CarryThrough/LifeManager

signal go_to_shop

var main_ball = BALL
var score := 0
var brick_count := 0

var paddle_timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_reset"):
			GlobalVariables.set_variables()
			remove_panels_hitbox()
			go_to_shop.emit()
			
	elif Input.is_action_just_pressed("clear_all_bricks"):
		print("Clear")
		
		for brick in get_tree().get_nodes_in_group("bricks"):
			brick.queue_free()
			
		level_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.level_won = true
	elif Input.is_action_just_pressed("gain_gold_button"):
		GlobalVariables.gold += 50
		gold_label.update_gold()

func instantiate_boundary(rect):
	var border = BOUNDARY.instantiate()
	border.set_position_and_size(rect)
	print(rect)
	border.player_colliding.connect(_on_boundary_player_colliding)
	border.process_physics_priority = 10
	add_child(border)

func instantiate_paddle(paddle_position):
	var paddle = PADDLE.instantiate()
	paddle.position = paddle_position
	add_child(paddle)
	paddle.paddle_size()
	paddle.add_to_group("paddle")
	
	
func instantiate_ball():
	var ball = BALL.instantiate()
	ball.level_started.connect(_level_started)
	add_child(ball)
	ball.get_paddle()
	main_ball = ball

func instantiate_brick(pos: Vector2, sprite: int):
	var brick = BRICK.instantiate()
	brick.position = pos
	add_child(brick)
	brick.choose_frame(sprite)
	brick.add_to_group("bricks")
	brick_count += 1
	
	#brick.tree_exited.connect(_on_brick_removed)
	
	brick.hit.connect(_on_brick_hit)
	brick.destroyed.connect(_on_brick_destroyed)

func instantiate_powerup(pos: Vector2) -> void:
	var powerup = POWERUP.instantiate()
	powerup.position = pos
	add_child(powerup)
	powerup.powerup_collected.connect(_on_powerup_collected)
	powerup.add_to_group("powerup")

func _on_button_pressed() -> void:
	$CarryThrough/Camera2D.zoom *= 0.5

func _on_boundary_player_colliding():
	$Paddle._player_colliding()

func _on_brick_hit(body):
	if not body.is_in_group("bricks"):
		return	# ignore non-brick collisions
	gold_label.update_gold()
	score_label.update_score()

func _on_brick_destroyed(position: Vector2):
	brick_count -= 1
	if randf() * 100 < GlobalVariables.powerup_chance:
		instantiate_powerup(position)
		print(position)
	if brick_count == 0:
		level_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.level_won = true

func start_scene():
	start_game_label.visible = true
	start_game_label.text = str("Level " + str(GlobalVariables.level) + ": Press Space to start")
	game_over_panel.visible = false
	level_win_panel.visible = false
	for child in get_children():
		if child != carry_through:
			child.queue_free()
	
	for i in GlobalVariables.max_lives:
		life_manager.add_lives_to_scene()
	
	score = 0
	brick_count = 0
	score_label.update_score()
	gold_label.update_gold()

	
	var window_size = Vector2(DisplayServer.window_get_size())
	var zoom = $CarryThrough/Camera2D.zoom
	var world_size = window_size / zoom
	
	#var rect1 = Rect2(
	#Vector2(0, -world_size[1] / 2 + 10),
	#Vector2(world_size[0] + 40, 150)
	#)
#
	#var rect2 = Rect2(
	#Vector2(-world_size[0] / 2, 0),
	#Vector2(60, world_size[1] + 40)
	#)
	#
	#var rect3 = Rect2(
	#Vector2(world_size[0] / 2, 0),
	#Vector2(60, world_size[1] + 40)
	#)
	
	var rect1 = Rect2(
	Vector2(0, -710),
	Vector2(2600, 150)
	)

	var rect2 = Rect2(
	Vector2(-1280, 0),
	Vector2(60, 1480)
	)
	
	var rect3 = Rect2(
	Vector2(1280, 0),
	Vector2(60, 1480)
	)
	
	instantiate_boundary(rect1)
	instantiate_boundary(rect2)
	instantiate_boundary(rect3)
	
	instantiate_paddle(GlobalVariables.paddle_position)
	
	instantiate_ball()
	for i in 10:
		for j in 4:
			var brick_position = Vector2(-4.5 * 248 + i * 248, -60 -j * 170)
			var add_brick = choose_brick_to_add(j)
			instantiate_brick(brick_position, add_brick)

func choose_brick_to_add(preferred_brick):
	if GlobalVariables.brick_change_chance == [0, 0, 0, 0]:
		return preferred_brick
		
	var base_weights = GlobalVariables.brick_change_chance
	var size = base_weights.size()
	
	var preferred_boost = 1.0
	var bias_power = 7.5
	
	var scores = []
	
	for j in range(size):
		var score = 0.0
		
		var bias = base_weights[j] / 80.0
		
		# Preferred node
		if j == preferred_brick:
			score += preferred_boost
		
		# Only biased nodes can steal
		if bias > 0:
			var distance = abs(j - preferred_brick)
			var decay = pow(0.1, distance)
			
			score += bias_power * bias * decay
		
		scores.append(score)
	
	# Normalize and pick
	var total = 0.0
	for s in scores:
		total += s
	
	if total == 0:
		return preferred_brick
	
	var r = randf() * total
	var cumulative = 0.0
	
	for i in range(size):
		cumulative += scores[i]
		if r <= cumulative:
			return i
	
	return preferred_brick

func _on_world_border_body_entered(body: Node2D) -> void:
	if GlobalVariables.remaining_lives != 0:
		life_manager.remove_life()
		for powerup in get_tree().get_nodes_in_group("powerup"):
			powerup.queue_free()
	
	if GlobalVariables.remaining_lives == 0:
		GlobalVariables.high_score_updated(GlobalVariables.current_score)
		game_over_label.display_high_score()
		game_over_panel.visible = true
	else:
		main_ball.ball_reset()

func _on_game_over_button_pressed() -> void:
	GlobalVariables.set_variables()
	remove_panels_hitbox()
	go_to_shop.emit()

func _on_next_level_button_pressed() -> void:
	remove_panels_hitbox()
	go_to_shop.emit()
	pass # Replace with function body.

func _level_started():
	start_game_label.visible = false

func _on_powerup_collected(powerup):
	if powerup == 0:
		
		if GlobalVariables.remaining_lives < GlobalVariables.max_lives:
			print("Extra Life")
			GlobalVariables.remaining_lives += 1
			for i in GlobalVariables.max_lives:
				life_manager.add_lives_to_scene()
	elif powerup == 1:
		print("Free Money")
		GlobalVariables.gold += 10
		gold_label.update_gold()
	elif powerup == 2:
		var timer: Timer = TEN_SECOND_TIMER.instantiate()
		timer.timeout.connect(_double_money_timer_timeout)
		GlobalVariables.gold_multiplier += 1
		add_child(timer)
		print("Double Money for a bit")
	elif powerup == 3:
		if paddle_timer == null or not is_instance_valid(paddle_timer):
			paddle_timer = TEN_SECOND_TIMER.instantiate()
			paddle_timer.wait_time = 20
			paddle_timer.one_shot = true
			paddle_timer.timeout.connect(_paddle_extension_timeout)
			add_child(paddle_timer)
			
		paddle_timer.start()
		
		for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.enable_side_panels()
		print("Longer paddles")


func _double_money_timer_timeout() -> void:
	GlobalVariables.gold_multiplier -= 1
	pass

func _paddle_extension_timeout() -> void:
	for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.disable_side_panels()

func remove_panels_hitbox() -> void:
	for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.remove_panel_hitbox()
