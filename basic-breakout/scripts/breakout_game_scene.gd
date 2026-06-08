extends Node2D
const Scenes = {
	"stage_win": preload("uid://cimjfypa0s4n4"),
	"powerup": preload("uid://cntm4nhm84n3n"),
	"ten_second_timer": preload("uid://8ik8vqkn7hep"),
	"darken_background": preload("uid://cy4yhp5w1mhqn"),
	"stats_menu": preload("uid://cvxqf1v5li07v"),
	"esc_menu": preload("uid://m5qr1cv8opq7"),
	"options_menu": preload("uid://cqnaxtof0tjio")
}

@onready var world_border: Area2D = $WorldBorder
@onready var game_over_panel: Panel = $CarryThrough/GameOver/Panel
@onready var stage_win_panel: PanelContainer = $CarryThrough/StageWin/PanelContainer
@onready var score_label: PanelContainer = $CarryThrough/ScorePanelContainer
@onready var game_over_label: Label = $CarryThrough/GameOver/Panel/GameOverLabel
@onready var carry_through: Node2D = $CarryThrough
@onready var gold_label: Label = $CarryThrough/GoldPanelContainer/GoldLabel
@onready var start_game_label: Label = $CarryThrough/StartGameLabel
@onready var life_manager: Node = $CarryThrough/Managers/LifeManager
@onready var xp_panel_container: PanelContainer = $CarryThrough/XPPanelContainer
@onready var level_up_panel: Panel = $CarryThrough/LevelUpPanel
@onready var tooltip_panel_container: PanelContainer = $CarryThrough/TooltipPanelContainer
@onready var stats_panel_container: PanelContainer = $CarryThrough/StatsPanelContainer
@onready var brick_sound_effects: AudioStreamPlayer2D = $CarryThrough/Audio/BrickSoundEffects
@onready var xp_sound_effects: AudioStreamPlayer2D = $CarryThrough/Audio/XPSoundEffects
@onready var powerup_sound_effects: AudioStreamPlayer2D = $CarryThrough/Audio/PowerupSoundEffects
@onready var audio: Node = $CarryThrough/Audio
@onready var options_menu: Control = $CarryThrough/OptionsMenu
@onready var stage_manager: Node = $CarryThrough/Managers/StageManager
@onready var xp_manager: Node = $CarryThrough/Managers/XPManager
@onready var powerup_manager: Node = $CarryThrough/Managers/PowerupManager



enum PowerupType {
	EXTRA_LIFE,
	MONEY,
	DOUBLE_MONEY,
	LONG_PADDLE,
	XP_MAGNET
}

signal go_to_shop
signal game_over
signal go_to_menu

var score := 0
var brick_count := 0

var stats_menu
var menu_open = false
var current_esc_menu: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage_manager.game_scene = self
	xp_manager.game_scene = self
	powerup_manager.game_scene = self
	GoToMenu.open_menu.connect(_open_esc_menu)
	start_scene()

func _input(event):
	if event.is_action_pressed("debug_reset"):
			GlobalVariables.set_variables()
			LevelUpVariables.set_variables()
			remove_panels_hitbox()
			_go_to_shop()
			
	elif event.is_action_pressed("clear_all_bricks"):
		print("Clear")
		
		for brick in get_tree().get_nodes_in_group("bricks"):
			brick.queue_free()
		show_stage_win()
		
	elif event.is_action_pressed("gain_gold_button"):
		GlobalVariables.gold += 50
		update_gold(50)
	elif event.is_action_pressed("gain_xp"):
		GlobalVariables.xp += 150
		xp_panel_container.update_xp(true)


#func instantiate_powerup(pos: Vector2) -> void:
	#var powerup = spawn(Scenes.powerup, pos)
	#powerup.powerup_collected.connect(_on_powerup_collected)
	#powerup.add_to_group("powerup")

func _on_boundary_player_colliding():
	$Paddle._player_colliding()

func _on_brick_hit(body):
	if not body.is_in_group("bricks"):
		return	# ignore non-brick collisions
	update_gold()
	score_label.update_score()
	brick_sound_effects.play_brick_hit()
	balance_sounds()

func _on_brick_destroyed(position: Vector2, powerup_spawn: bool, extra_xp: bool = false):
	brick_sound_effects.play_brick_destroyed()
	balance_sounds()

	if extra_xp:
		xp_manager.instantiate_xp(position + Vector2(30, 0))
		xp_manager.instantiate_xp(position + Vector2(-30, 0))
	else:
		xp_manager.instantiate_xp(position)
	if powerup_spawn:
		powerup_manager.instantiate_powerup(position)
	
	stage_manager.brick_destroyed()

func start_scene():
	GlobalVariables.levels_gained = 0
	set_start_text()
	start_game_label.visible = true
	game_over_panel.visible = false
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

	stage_manager.start_stage()

func _on_world_border_body_entered(body: Node2D) -> void:
	print(body)
	if !body.slow_ball:
		if GlobalVariables.remaining_lives != 0:
			life_manager.remove_life()
			
			for slow_ball in get_group("slow_ball"):
				await slow_ball.animate_destroy()
				slow_ball.queue_free()
			for xp in get_group("xp"):
				xp.go_to_paddle()
		
		stage_manager.stop_level_timers()
		Signals.lives_lost.emit()
		if GlobalVariables.remaining_lives <= 0:
			for powerup in get_group("powerup"):
				powerup.queue_free()
			for laser in get_group("invincible"):
				laser.stopping = true
			show_dark_background()
			GlobalVariables.high_score_updated(GlobalVariables.current_score)
			end_of_the_game()

			if GlobalVariables.high_score > SaveLoad.highest_record:
				SaveLoad.highest_record = GlobalVariables.high_score
			SaveLoad.save_score()
			Signals.game_over.emit()
			for slow_ball in get_group("slow_ball"):
				await slow_ball.animate_destroy()
				slow_ball.queue_free()
			
		
		else:
			stage_manager.create_balls()

	else:
		if LevelUpVariables.slow_ball_bounces_off_bottom:
			body.velocity.y = -body.velocity.y
		else:
			body.queue_free()

func _on_world_border_area_entered(area: Area2D) -> void:
	if !area.get_parent() in get_group("invincible"):
		area.get_parent().queue_free()

func show_dark_background():
	var darken_background = Scenes.darken_background.instantiate()
	darken_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	make_mouse_ignore(darken_background)
	add_child(darken_background)
	darken_background.add_to_group("dark_background")

func make_mouse_ignore(node: Node):
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	for child in node.get_children():
		make_mouse_ignore(child)

func end_of_the_game():
	remove_panels_hitbox()
	var esc_menu = spawn(Scenes.esc_menu)

	esc_menu.go_to_shop.connect(_go_to_shop)
	esc_menu.game_over_panel()
	esc_menu.open_options.connect(_open_options)
	esc_menu.go_to_menu.connect(_go_to_menu)
	current_esc_menu = esc_menu
	menu_open = true

func _on_next_stage_button_pressed() -> void:
	remove_panels_hitbox()
	if GlobalVariables.levels_gained > 0:
		
		for i in get_group("stage_win_panel"):
			i.queue_free()
		level_up_panel.activate()
		level_up_panel.visible = true
		stats_panel_container.visible = true
		GlobalVariables.levels_gained -= 1
		
	else:
		GlobalVariables.levels_gained = 0
		_go_to_shop()

func _stage_started():
	start_game_label.visible = false
	stage_manager.stage_started_func()



func remove_panels_hitbox() -> void:
	for paddle in get_group("paddle"):
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
	stats_menu = spawn(Scenes.stats_menu, Vector2(-750, -625))
	stats_menu.display_in_game_stats()

func update_gold(gold_gained = 0):
	gold_label.update_gold()
	if gold_gained != 0:
		Signals.gold_gained.emit(gold_gained)

func _open_esc_menu():
	if !menu_open and !stats_menu:
		var esc_menu = create_esc_menu()
		menu_open = true
		show_dark_background()
		get_tree().paused = true

func _close_esc_menu():
	var can_unpause = true
	for i in get_group("pause_locked"):
		can_unpause = false
	if can_unpause:
		get_tree().paused = false
		for esc_menu in get_group("esc_menu"):
			esc_menu.close_menu()
		menu_open = false
		for child in get_children():
			if child in get_group("dark_background"):
				child.queue_free()
		set_start_text()

func _go_to_menu():
	MetaStats._game_over()
	GlobalVariables.set_variables()
	LevelUpVariables.set_variables()
	go_to_menu.emit()

func _go_to_shop(restart = false):
	if restart:
		Signals.games_played.emit()
	go_to_shop.emit()

func balance_sounds():
	for child in audio.get_children():
		if child is AudioStreamPlayer2D and not child.is_in_group("keep_volume"):
			for sound in child.get_children():
				create_tween().tween_property(
					sound,
					"volume_db",
					sound.volume_db - 2,
					0.05
			)

func _open_options():
	if current_esc_menu:
		if !current_esc_menu.options_opened:
			var options_menu = Scenes.options_menu.instantiate()
			options_menu.closed.connect(_options_menu_closed)
			options_menu.add_to_group("options_menu")
			options_menu.add_to_group("pause_locked")
			add_child(options_menu)
			options_menu.process_mode = 3

func _options_menu_closed():
	for options_menu in get_group("options_menu"):
		options_menu.queue_free()
	if current_esc_menu:
		current_esc_menu.options_closed()

func spawn(scene: PackedScene, pos := Vector2.ZERO) -> Node:
	var node = scene.instantiate()
	node.position = pos
	add_child(node)
	return node

func show_stage_win() -> void:
	show_dark_background()

	var panel = spawn(Scenes.stage_win)

	panel.next_stage.connect(_on_next_stage_button_pressed)
	panel.add_to_group("stage_win_panel")

	stage_manager.get_main_ball().in_motion = false
	stage_manager.get_main_ball().stage_won = true

func get_group(group_name: StringName) -> Array:
	return get_tree().get_nodes_in_group(group_name)

func create_timer(duration: float, callback: Callable, powerup := false, one_shot := true) -> Timer:
	var timer: Timer = Scenes.ten_second_timer.instantiate()
	timer.wait_time = duration
	timer.timeout.connect(callback)
	
	if powerup:
		timer.one_shot = one_shot
		if LevelUpVariables.double_powerup_timer:
			timer.wait_time *= 2
		
	add_child(timer)
	return timer

func create_esc_menu() -> Node:
	var menu = spawn(Scenes.esc_menu)
	current_esc_menu = menu
	menu.close.connect(_close_esc_menu)
	menu.go_to_menu.connect(_go_to_menu)
	menu.open_options.connect(_open_options)
	menu.add_to_group("esc_menu")
	return menu

func set_start_text():
	var action_events = InputMap.action_get_events("start_game")
	start_game_label.text = str("Stage " + str(GlobalVariables.stage) + ": Press " + OS.get_keycode_string(action_events[0].physical_keycode) + " to start")
