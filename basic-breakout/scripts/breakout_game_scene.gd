extends Node2D

const BOUNDARY = preload("uid://d772en1051bk")
const PADDLE = preload("uid://tbgughlh81ae")
const BALL = preload("uid://cuaeu3do68vtt")
const BRICK = preload("uid://yuqauunfvg2t")
const LIVES = preload("uid://v36pc1cur2mv")
@onready var world_border: Area2D = $WorldBorder
@onready var game_over_panel: Panel = $CarryThrough/GameOver/Panel
@onready var level_win_panel: PanelContainer = $CarryThrough/LevelWin/PanelContainer
@onready var score_label: Label = $CarryThrough/ScorePanelContainer/ScoreLabel
@onready var game_over_label: Label = $CarryThrough/GameOver/Panel/GameOverLabel
@onready var carry_through: Node2D = $CarryThrough
@onready var gold_label: Label = $CarryThrough/GoldPanelContainer/GoldLabel

signal go_to_shop

var main_ball = BALL
var list_of_lives := []
var score := 0
var brick_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		instantiate_lives(Vector2(794 + 75 * i, -675))
	start_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_reset"):
			start_scene()
	elif Input.is_action_just_pressed("clear_all_bricks"):
		print("Clear")
		
		for brick in get_tree().get_nodes_in_group("bricks"):
			brick.queue_free()
			
		level_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.level_won = true

func instantiate_boundary(rect):
	var border = BOUNDARY.instantiate()
	border.set_position_and_size(rect)
	border.player_colliding.connect(_on_boundary_player_colliding)
	border.process_physics_priority = 10
	add_child(border)

func instantiate_paddle(paddle_position):
	var paddle = PADDLE.instantiate()
	paddle.position = paddle_position
	add_child(paddle)
	
func instantiate_ball():
	var ball = BALL.instantiate()
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

func instantiate_lives(pos: Vector2):
	var life := LIVES.instantiate()
	life.position = pos
	life.z_index = 50
	carry_through.add_child(life)
	list_of_lives.append(life)

func _on_button_pressed() -> void:
	$CarryThrough/Camera2D.zoom *= 0.5

func _on_boundary_player_colliding():
	$Paddle._player_colliding()

func _on_brick_hit(body):
	if not body.is_in_group("bricks"):
		return	# ignore non-brick collisions

	print("Hit")
	score = main_ball.max_speed - main_ball.initial_speed
	
	GlobalVariables.score_updated(score)
	gold_label.update_gold()
	score_label.update_score(GlobalVariables.current_score)

func _on_brick_destroyed():
	brick_count -= 1
	print("Destroyed")
	print(brick_count)
	if brick_count == 0:
		level_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.level_won = true

func start_scene():
	game_over_panel.visible = false
	level_win_panel.visible = false
	for child in get_children():
		if child != carry_through:
			child.queue_free()
	for life in list_of_lives:
		life.frame = 0
	GlobalVariables.remaining_lives = 3
	score = 0
	brick_count = 0
	score_label.update_score(0)
	var window_size = Vector2(DisplayServer.window_get_size())
	var zoom = $CarryThrough/Camera2D.zoom
	var world_size = window_size / zoom
	
	var rect1 = Rect2(
	Vector2(0, -world_size[1] / 2 + 10),
	Vector2(world_size[0] + 40, 150)
	)

	var rect2 = Rect2(
	Vector2(-world_size[0] / 2, 0),
	Vector2(60, world_size[1] + 40)
	)
	
	var rect3 = Rect2(
	Vector2(world_size[0] / 2, 0),
	Vector2(60, world_size[1] + 40)
	)
	
	var paddle_position = Vector2(0, 470)
	
	instantiate_boundary(rect1)
	instantiate_boundary(rect2)
	instantiate_boundary(rect3)
	
	instantiate_paddle(paddle_position)
	
	instantiate_ball()
	for i in 10:
		for j in 4:
			
			var brick_position = Vector2(-4.5 * 248 + i * 248, -50 -j * 175)
			instantiate_brick(brick_position, j)

func _on_world_border_body_entered(body: Node2D) -> void:
	if GlobalVariables.remaining_lives != 0:
		var finalised_life_lost = false
		for life in list_of_lives:
			if life.frame == 0:
				life.frame = 1
				GlobalVariables.remaining_lives -= 1
				break

	if GlobalVariables.remaining_lives == 0:
		game_over_label.display_high_score()
		game_over_panel.visible = true
	else:
		main_ball.ball_reset()

func _on_game_over_button_pressed() -> void:
	start_scene()

func _on_next_level_button_pressed() -> void:
	print("Trying to go shop")
	go_to_shop.emit()
	pass # Replace with function body.
