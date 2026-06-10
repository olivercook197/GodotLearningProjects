extends Node

const Scenes = {
	"powerup": preload("uid://cntm4nhm84n3n"),
	"ten_second_timer": preload("uid://8ik8vqkn7hep")
}

enum PowerupType {
	EXTRA_LIFE,
	MONEY,
	DOUBLE_MONEY,
	LONG_PADDLE,
	XP_MAGNET
}

@onready var powerup_sound_effects: AudioStreamPlayer2D = $"../../Audio/PowerupSoundEffects"
@onready var xp_manager: Node = $"../XPManager"
@onready var audio: Audio = $"../../Audio"

var game_scene: Node

var paddle_timer: Timer = null
var xp_timer: Timer = null
var magnet_xp: bool = false


func instantiate_powerup(pos: Vector2) -> void:
	var powerup = spawn(Scenes.powerup, pos)
	powerup.powerup_collected.connect(_on_powerup_collected)
	powerup.add_to_group("powerup")

func spawn(scene: PackedScene, pos := Vector2.ZERO) -> Node:
	var node = scene.instantiate()
	node.position = pos
	add_child(node)
	return node

func _on_powerup_collected(powerup):
	audio.balance_sounds()
	powerup_sound_effects.play_gain_powerup()
	if LevelUpVariables.powerup_gives_xp_gold_score:
		GlobalVariables.current_score += 5 * GlobalVariables.score_multiplier
		GlobalVariables.gold += 5 * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier
		GlobalVariables.xp += 5 * GlobalVariables.bonus_xp
		game_scene.update_gold(5 * GlobalVariables.global_gold_multiplier * GlobalVariables.local_gold_multiplier)
		xp_manager.xp_panel_container.update_xp(true)
		game_scene.score_label.update_score()
	Signals.powerup_collected.emit()
	match powerup:
		PowerupType.EXTRA_LIFE:
			if GlobalVariables.remaining_lives < GlobalVariables.max_lives and GlobalVariables.remaining_lives != 0:
				GlobalVariables.remaining_lives += 1
				for i in GlobalVariables.max_lives:
					game_scene.life_manager.add_lives_to_scene()
		PowerupType.MONEY:
			GlobalVariables.gold += 5 + 5 * GlobalVariables.stage
			game_scene.update_gold(5 + 5 * GlobalVariables.stage)
		PowerupType.DOUBLE_MONEY:
			create_timer(10, _double_money_timer_timeout, true)
			GlobalVariables.local_gold_multiplier += 1
		PowerupType.LONG_PADDLE:
			if paddle_timer != null:
				paddle_timer.queue_free()

			paddle_timer = create_timer(20, _paddle_extension_timeout)
			for paddle in get_group("paddle"):
				paddle.enable_side_panels()
		PowerupType.XP_MAGNET:
			for xp in get_group("xp"):
				xp.go_to_paddle()
			magnet_xp = true
			if xp_timer == null or not is_instance_valid(xp_timer):
				xp_timer = create_timer(20, _xp_magnet_timeout, true)

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

func _double_money_timer_timeout() -> void:
	GlobalVariables.local_gold_multiplier -= 1

func _paddle_extension_timeout() -> void:
	for paddle in get_group("paddle"):
		paddle.disable_side_panels()
	paddle_timer.queue_free()

func _xp_magnet_timeout() -> void:
	magnet_xp = false
	xp_timer.queue_free()

func get_group(group_name: StringName) -> Array:
	return get_tree().get_nodes_in_group(group_name)
