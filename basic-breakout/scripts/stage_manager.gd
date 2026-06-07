extends Node

const Scenes = {
	"boundary": preload("uid://d772en1051bk"),
	"paddle": preload("uid://tbgughlh81ae"),
	"ball": preload("uid://cuaeu3do68vtt"),
	"brick": preload("uid://yuqauunfvg2t"),
	"lives": preload("uid://v36pc1cur2mv"),
	"stage_win": preload("uid://cimjfypa0s4n4"),
	"ten_second_timer": preload("uid://8ik8vqkn7hep"),
	"laser": preload("res://scenes/end_game_laser.tscn")
	
}

signal stage_started
signal stage_completed
signal next_stage_requested

var brick_count := 0
var main_ball: Ball

var end_game := false

var game_scene: Node

func start_stage():
	brick_count = 0

	create_boundaries()
	create_paddle(GlobalVariables.paddle_position)
	create_balls()
	create_bricks()

func create_bricks():
	for i in 10:	#10
		for j in 4:	#4
			var brick_position = Vector2(-4.5 * 248 + i * 248, -60 -j * 170)
			var add_brick = choose_brick_to_add(j)
			instantiate_brick(brick_position, add_brick)
	game_scene.brick_count = brick_count

func create_boundaries():
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

func instantiate_boundary(rect):
	var border = spawn(Scenes.boundary)
	border.set_position_and_size(rect)
	border.process_physics_priority = 10

func create_paddle(paddle_position):
	var paddle = spawn(Scenes.paddle, paddle_position)
	paddle.paddle_size()
	paddle.add_to_group("paddle")

func create_balls():
	spawn_ball(false,true)
	if LevelUpVariables.start_with_extra_slow_ball:
		spawn_ball(true)
	if LevelUpVariables.start_with_second_slow_ball:
		spawn_ball(true, false, true)

func spawn_ball(spawn_slow_ball = false, spawn_main_ball = false, spawn_to_right = false):
	var ball = spawn(Scenes.ball)
	ball.sound_played.connect(game_scene.balance_sounds)
	ball.get_paddle()
	if spawn_slow_ball:
		ball.make_slow_ball()
		ball.add_to_group("slow_ball")
	if spawn_main_ball:
		main_ball = ball
		ball.stage_started.connect(game_scene._stage_started)
		ball.add_to_group("main_ball")
	if spawn_to_right:
		ball.go_to_right = true
	ball.add_to_group("ball")

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

func instantiate_brick(pos: Vector2, sprite: int):
	var brick = spawn(Scenes.brick, pos)
	brick.choose_frame(sprite)
	brick.add_to_group("bricks")
	brick_count += 1
	
	brick.hit.connect(game_scene._on_brick_hit)
	brick.destroyed.connect(game_scene._on_brick_destroyed)

func spawn(scene: PackedScene, pos := Vector2.ZERO) -> Node:
	var node = scene.instantiate()
	node.position = pos
	game_scene.add_child(node)
	return node

func reset_main_ball():
	main_ball.ball_reset()

func stage_started_func():
	if LevelUpVariables.destroy_random_brick:
		var timer = create_timer_no_powerup(10, _destroy_random_brick)
		timer.one_shot = false
		timer.add_to_group("level_timer")

func stop_level_timers():
	for timer in game_scene.get_group("level_timer"):
		timer.queue_free()

func _destroy_random_brick():
	var brick_list = []
	for brick in game_scene.get_group("bricks"):
		brick_list.append(brick)
	var destroyed_brick: Brick = brick_list.pick_random()
	if destroyed_brick != null:
		for ball:Ball in game_scene.get_group("main_ball"):
			ball.hit_brick_logic(destroyed_brick)
		destroyed_brick.on_hit()

func create_timer_no_powerup(duration: float, callback: Callable, one_shot := true) -> Timer:
	var timer: Timer = Scenes.ten_second_timer.instantiate()
	timer.wait_time = duration
	timer.timeout.connect(callback)

	add_child(timer)
	return timer

func get_group(group_name: StringName) -> Array:
	return get_tree().get_nodes_in_group(group_name)

func brick_destroyed():
	brick_count -= 1
	
	if brick_count == 0:
		game_scene.show_stage_win()

		for xp in get_group("xp"):
			xp.go_to_paddle()
			
		for slow_ball in get_group("slow_ball"):
			await slow_ball.animate_destroy()
			slow_ball.queue_free()
	if brick_count < GlobalVariables.laser_threshold and !end_game:
		instantiate_laser(Vector2(-1228, 120))
		end_game = true
		

func instantiate_laser(pos: Vector2):
	var laser = spawn(Scenes.laser, pos)
	laser.max_x = 2452
	laser.add_to_group("invincible")
	game_scene.add_child(laser)

func get_main_ball() -> Ball:
	return main_ball
