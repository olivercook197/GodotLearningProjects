extends Node2D

const BOUNDARY = preload("uid://d772en1051bk")
const PADDLE = preload("uid://tbgughlh81ae")
const BALL = preload("uid://cuaeu3do68vtt")
const BRICK = preload("uid://yuqauunfvg2t")
const LIVES = preload("uid://v36pc1cur2mv")
const POWERUP = preload("uid://cntm4nhm84n3n")
const TEN_SECOND_TIMER = preload("uid://8ik8vqkn7hep")
const DARKEN_BACKGROUND = preload("uid://cy4yhp5w1mhqn")
const XP_CRYSTAL = preload("uid://bsa8wwffqb71y")
const STATS_MENU = preload("uid://cvxqf1v5li07v")

@onready var world_border: Area2D = $WorldBorder
@onready var game_over_panel: Panel = $CarryThrough/GameOver/Panel
@onready var stage_win_panel: PanelContainer = $CarryThrough/StageWin/PanelContainer
@onready var score_label: PanelContainer = $CarryThrough/ScorePanelContainer
@onready var game_over_label: Label = $CarryThrough/GameOver/Panel/GameOverLabel
@onready var carry_through: Node2D = $CarryThrough
@onready var gold_label: Label = $CarryThrough/GoldPanelContainer/GoldLabel
@onready var start_game_label: Label = $CarryThrough/StartGameLabel
@onready var life_manager: Node = $CarryThrough/LifeManager
@onready var xp_panel_container: PanelContainer = $CarryThrough/XPPanelContainer
@onready var level_up_panel: Panel = $CarryThrough/LevelUpPanel
@onready var tooltip_panel_container: PanelContainer = $CarryThrough/TooltipPanelContainer
@onready var stats_panel_container: PanelContainer = $CarryThrough/StatsPanelContainer

signal go_to_shop
signal game_over

var main_ball = BALL
var score := 0
var brick_count := 0

var paddle_timer: Timer = null
var xp_timer: Timer = null
var magnet_xp: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_reset"):
			GlobalVariables.set_variables()
			LevelUpVariables.set_variables()
			remove_panels_hitbox()
			go_to_shop.emit()
			
	elif Input.is_action_just_pressed("clear_all_bricks"):
		print("Clear")
		
		for brick in get_tree().get_nodes_in_group("bricks"):
			brick.queue_free()
			
		stage_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.stage_won = true
	elif Input.is_action_just_pressed("gain_gold_button"):
		GlobalVariables.gold += 50
		update_gold(50)
	elif Input.is_action_just_pressed("gain_xp"):
		GlobalVariables.xp += 150
		xp_panel_container.update_xp(true)
		

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
	paddle.paddle_size()
	paddle.add_to_group("paddle")
	
	
func instantiate_ball(spawn_slow_ball = false, spawn_main_ball = false, spawn_to_right = false):
	var ball = BALL.instantiate()
	add_child(ball)
	ball.get_paddle()
	if spawn_slow_ball:
		ball.make_slow_ball()
		ball.add_to_group("slow_ball")
	if spawn_main_ball:
		main_ball = ball
		ball.stage_started.connect(_stage_started)
		ball.add_to_group("main_ball")
	if spawn_to_right:
		ball.go_to_right = true
	ball.add_to_group("ball")

func instantiate_brick(pos: Vector2, sprite: int):
	var brick = BRICK.instantiate()
	brick.position = pos
	add_child(brick)
	brick.choose_frame(sprite)
	brick.add_to_group("bricks")
	brick_count += 1
	
	brick.hit.connect(_on_brick_hit)
	brick.destroyed.connect(_on_brick_destroyed)

func instantiate_powerup(pos: Vector2) -> void:
	var powerup = POWERUP.instantiate()
	powerup.position = pos
	add_child(powerup)
	powerup.powerup_collected.connect(_on_powerup_collected)
	powerup.add_to_group("powerup")

func instantiate_xp(pos: Vector2) -> void:
	var xp = XP_CRYSTAL.instantiate()
	xp.position = pos + Vector2(randi_range(-35, 35), randi_range(-15, 15))
	add_child(xp)
	xp.xp_collected.connect(_on_xp_collected)
	xp.add_to_group("xp")
	if magnet_xp:
		xp.go_to_paddle()

func _on_button_pressed() -> void:
	$CarryThrough/Camera2D.zoom *= 0.5

func _on_boundary_player_colliding():
	$Paddle._player_colliding()

func _on_brick_hit(body):
	if not body.is_in_group("bricks"):
		return	# ignore non-brick collisions
	update_gold()
	score_label.update_score()

func _on_brick_destroyed(position: Vector2, powerup_spawn: bool, extra_xp: bool = false):
	brick_count -= 1
	
	if extra_xp:
		instantiate_xp(position + Vector2(30, 0))
		instantiate_xp(position + Vector2(-30, 0))
	else:
		instantiate_xp(position)
	if powerup_spawn:
		instantiate_powerup(position)
	if brick_count == 0:
		show_dark_background()
		stage_win_panel.visible = true
		main_ball.in_motion = false
		main_ball.stage_won = true
		for xp in get_tree().get_nodes_in_group("xp"):
			xp.go_to_paddle()
			
		for slow_ball in get_tree().get_nodes_in_group("slow_ball"):
			await slow_ball.animate_destroy()
			slow_ball.queue_free()

func start_scene():
	GlobalVariables.levels_gained = 0
	
	start_game_label.visible = true
	start_game_label.text = str("Stage " + str(GlobalVariables.stage) + ": Press Space to start")
	game_over_panel.visible = false
	stage_win_panel.visible = false
	level_up_panel.visible = false
	stats_panel_container.visible = false
	for child in get_children():
		if child != carry_through:
			child.queue_free()
	
	for i in GlobalVariables.max_lives:
		life_manager.add_lives_to_scene()
	
	score = 0
	brick_count = 0
	score_label.update_score()
	update_gold()
	GlobalVariables.ball_speed -= GlobalVariables.speed_decrease_on_stage_start

	
	var window_size = Vector2(DisplayServer.window_get_size())
	var zoom = $CarryThrough/Camera2D.zoom
	var world_size = window_size / zoom

	
	var rect1 = Rect2(
	Vector2(0, -710),
	Vector2(2600, 150)
	)

	var rect2 = Rect2(
	Vector2(-1280, 0),
	Vector2(60, 1600)
	)
	
	var rect3 = Rect2(
	Vector2(1280, 0),
	Vector2(60, 1600)
	)
	
	instantiate_boundary(rect1)
	instantiate_boundary(rect2)
	instantiate_boundary(rect3)
	
	instantiate_paddle(GlobalVariables.paddle_position)
	
	instantiate_ball(false, true)
	if LevelUpVariables.start_with_extra_slow_ball:
		instantiate_ball(true)
	if LevelUpVariables.start_with_second_slow_ball:
		instantiate_ball(true, false, true)
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
		var spawn_score = 0.0
		
		var bias = base_weights[j] / 80.0
		
		# Preferred node
		if j == preferred_brick:
			spawn_score += preferred_boost
		
		# Only biased nodes can steal
		if bias > 0:
			var distance = abs(j - preferred_brick)
			var decay = pow(0.1, distance)
			
			spawn_score += bias_power * bias * decay
		
		scores.append(spawn_score)
	
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
	print(body)
	if !body.slow_ball:
		if GlobalVariables.remaining_lives != 0:
			life_manager.remove_life()
			
			for slow_ball in get_tree().get_nodes_in_group("slow_ball"):
				await slow_ball.animate_destroy()
				slow_ball.queue_free()
			for xp in get_tree().get_nodes_in_group("xp"):
				xp.go_to_paddle()
		
		stop_level_timers()
		Signals.lives_lost.emit()
		if GlobalVariables.remaining_lives <= 0:
			for powerup in get_tree().get_nodes_in_group("powerup"):
				powerup.queue_free()
			show_dark_background()
			GlobalVariables.high_score_updated(GlobalVariables.current_score)
			game_over_label.display_high_score()
			game_over_panel.z_index = 1000
			game_over_panel.visible = true
			game_over.emit()
			if GlobalVariables.high_score > SaveLoad.highest_record:
				SaveLoad.highest_record = GlobalVariables.high_score
			SaveLoad.save_score()
			Signals.game_over.emit()
			for slow_ball in get_tree().get_nodes_in_group("slow_ball"):
				await slow_ball.animate_destroy()
				slow_ball.queue_free()
			
		
		else:
			main_ball.ball_reset()
			if LevelUpVariables.start_with_extra_slow_ball:
				instantiate_ball(true)
			if LevelUpVariables.start_with_second_slow_ball:
				instantiate_ball(true, false, true)
	else:
		if LevelUpVariables.slow_ball_bounces_off_bottom:
			body.velocity.y = -body.velocity.y
		else:
			body.queue_free()

func _on_world_border_area_entered(area: Area2D) -> void:
	if area != Ball:
		area.get_parent().queue_free()
	

func show_dark_background():
	var darken_background = DARKEN_BACKGROUND.instantiate()
	darken_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(darken_background)

func _on_game_over_button_pressed() -> void:
	GlobalVariables.set_variables()
	LevelUpVariables.set_variables()
	remove_panels_hitbox()
	go_to_shop.emit()
	Signals.games_played.emit()

func _on_next_stage_button_pressed() -> void:
	remove_panels_hitbox()
	if GlobalVariables.levels_gained > 0:
		stage_win_panel.visible = false
		level_up_panel.activate()
		level_up_panel.visible = true
		stats_panel_container.visible = true
		GlobalVariables.levels_gained -= 1
		
	else:
		GlobalVariables.levels_gained = 0
		go_to_shop.emit()

func _stage_started():
	start_game_label.visible = false
	if LevelUpVariables.destroy_random_brick:
		var timer:Timer = TEN_SECOND_TIMER.instantiate()
		timer.wait_time = 10
		timer.autostart = true
		timer.one_shot = false
		timer.timeout.connect(_destroy_random_brick)
		timer.add_to_group("level_timer")
		add_child(timer)
		

func stop_level_timers():
	for timer in get_tree().get_nodes_in_group("level_timer"):
		timer.queue_free()

func _destroy_random_brick():
	var brick_list = []
	for brick in get_tree().get_nodes_in_group("bricks"):
		brick_list.append(brick)
	var destroyed_brick: Brick = brick_list.pick_random()
	if destroyed_brick != null:
		for ball:Ball in get_tree().get_nodes_in_group("main_ball"):
			ball.hit_brick_logic(destroyed_brick)
		destroyed_brick.on_hit()


func _on_powerup_collected(powerup):
	if LevelUpVariables.powerup_gives_xp_gold_score:
		GlobalVariables.current_score += 5 * GlobalVariables.score_multiplier
		GlobalVariables.gold += 5 * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier
		GlobalVariables.xp += 5 * GlobalVariables.bonus_xp
		update_gold(5 * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier)
		xp_panel_container.update_xp(true)
		score_label.update_score()
		Signals.powerup_collected.emit()
	
	if powerup == 0:
		if GlobalVariables.remaining_lives < GlobalVariables.max_lives and GlobalVariables.remaining_lives != 0:
			print("Extra Life")
			GlobalVariables.remaining_lives += 1
			for i in GlobalVariables.max_lives:
				life_manager.add_lives_to_scene()
	elif powerup == 1:
		print("Free Money")
		GlobalVariables.gold += 5 + 5 * GlobalVariables.stage
		update_gold(5 + 5 * GlobalVariables.stage)
	elif powerup == 2:
		var timer: Timer = TEN_SECOND_TIMER.instantiate()
		if LevelUpVariables.double_powerup_timer:
			timer.wait_time *= 2
		timer.timeout.connect(_double_money_timer_timeout)
		GlobalVariables.local_gold_multiplier += 1
		add_child(timer)
		print("Double Money for a bit")
	elif powerup == 3:
		if paddle_timer == null or not is_instance_valid(paddle_timer):
			paddle_timer = TEN_SECOND_TIMER.instantiate()
			paddle_timer.wait_time = 20
			if LevelUpVariables.double_powerup_timer:
				paddle_timer.wait_time *= 2
			paddle_timer.one_shot = true
			paddle_timer.timeout.connect(_paddle_extension_timeout)
			add_child(paddle_timer)
			
		paddle_timer.start()
		
		for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.enable_side_panels()
		print("Longer paddles")
	elif powerup == 4:
		for xp in get_tree().get_nodes_in_group("xp"):
			xp.go_to_paddle()
		magnet_xp = true
		if xp_timer == null or not is_instance_valid(xp_timer):
			xp_timer = TEN_SECOND_TIMER.instantiate()
			xp_timer.wait_time = 20
			if LevelUpVariables.double_powerup_timer:
				xp_timer.wait_time *= 2
			xp_timer.one_shot = true
			xp_timer.timeout.connect(_xp_magnet_timeout)
			add_child(xp_timer)
		
		xp_timer.start()
		print("XP Magnet")

func _on_xp_collected(xp_collected):
	var actual_collected_xp: float = xp_collected * (1 + GlobalVariables.bonus_xp_percent) * (1 + GlobalVariables.current_score/10000.0)
	GlobalVariables.xp += actual_collected_xp
	#print(xp_collected)
	#print(actual_collected_xp)
	GlobalVariables.bonus_xp += actual_collected_xp - xp_collected
	xp_panel_container.update_xp(true)
	Signals.xp_gained.emit(actual_collected_xp)

func _double_money_timer_timeout() -> void:
	GlobalVariables.local_gold_multiplier -= 1

func _paddle_extension_timeout() -> void:
	for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.disable_side_panels()

func _xp_magnet_timeout() -> void:
	magnet_xp = false

func remove_panels_hitbox() -> void:
	for paddle in get_tree().get_nodes_in_group("paddle"):
			paddle.remove_panel_hitbox()


func _on_level_up_panel_level_up_chosen(update_gold_panel: bool, gold_gained) -> void:
	if update_gold_panel:
		update_gold(gold_gained)
		
	_on_next_stage_button_pressed()



func _on_level_up_panel_level_up_hovered(tooltip: String) -> void:
	tooltip_panel_container.update_text(tooltip)
	tooltip_panel_container.visible = true


func _on_level_up_panel_level_up_stopped_hovering() -> void:
	tooltip_panel_container.visible = false


func _on_stats_panel_container_open_stats_menu() -> void:
	var stats_menu = STATS_MENU.instantiate()
	add_child(stats_menu)

func update_gold(gold_gained = 0):
	gold_label.update_gold()
	if gold_gained != 0:
		Signals.gold_gained.emit(gold_gained)
