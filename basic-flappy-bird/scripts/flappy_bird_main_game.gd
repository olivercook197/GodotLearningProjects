extends Node2D

const WHOLE_PIPE = preload("uid://sleiminlnouu")
const GROUND = preload("uid://crgknxdifkp6x")
const SCORE_LABEL = preload("uid://dhegv5kxm7pdg")
const GAME_END_LABEL = preload("uid://bn8qu1blvd0i1")
const SKY = preload("uid://d0yj2tmrkgetu")

var pixels_moved := 0

@onready var player: CharacterBody2D = $Player

var move_forward := true

var player_score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var initial_draw_x_ground = -48
	var draw_y = 48
	var initial_draw_x_pipe = 72
	# add pipes
	for i in 2:
		var pipe = WHOLE_PIPE.instantiate()
		$".".add_child(pipe)         
		pipe.set_position(Vector2(initial_draw_x_pipe + i * 60, randi_range(-28, 40)))
		pipe.player_died.connect(_on_killzone_player_died)
		pipe.player_scored.connect(_on_point_score_collision_player_scored)
	
	#fill in background
	for i in 9:
		var instance = GROUND.instantiate()
		$".".add_child(instance)
		instance.set_position(Vector2(initial_draw_x_ground + i * 16, draw_y))
		for j in 9:
			var sky_instance = SKY.instantiate()
			$".".add_child(sky_instance)
			sky_instance.set_position(Vector2(initial_draw_x_ground + i * 16, draw_y - j * 16))
	
	var score_label_instance = SCORE_LABEL.instantiate()
	$".".add_child(score_label_instance)
	score_label_instance.set_position(Vector2(24, -82))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_forward:
		pixels_moved += 1
		var children = get_children(false)
		for child in children:
			if child is Ground or child is WholePipe:
				child.position.x -= 1
			if child is SkyBackground:
				if pixels_moved % 2 == 0:
					child.position.x -= 1


func _on_killzone_player_died(name):
	if str(name) != "Killzone":
		move_forward = false
	player.player_died(name)
	var game_end_label = GAME_END_LABEL.instantiate()
	$".".add_child(game_end_label)
	game_end_label.set_position(Vector2(-30, 0))
	game_end_label.player_died(player_score, HighScore.player_high_score)

func _on_point_score_collision_player_scored():
	player_score += 1
	var children = get_children(false)
	for child in children:
			if child is Label:
				child.add_score(player_score)
	if player_score > HighScore.player_high_score:
		HighScore.player_high_score = player_score
