extends Node2D

var taken_level_ups: = {}
var destroy_random_brick = false
var double_powerup_timer = false
var start_with_extra_slow_ball = false
var start_with_second_slow_ball = false
var slow_ball_bounces_off_bottom = false
var brick3_cracked_multiplier = 2
var brick0_increases_gold_multiplier = false
var powerup_gives_xp_gold_score = false

enum RequirementsLevelUpLevels {
	START_WITH_EXTRA_SLOW_BALL,
	INCREASE_BRICK0_SPAWN,
	INCREASE_BRICK1_SPAWN,
	INCREASE_BRICK2_SPAWN,
	INCREASE_BRICK3_SPAWN
}

var level_up_id_list = {
	}

func set_variables():
	taken_level_ups = {}
	destroy_random_brick = false
	double_powerup_timer = false
	start_with_extra_slow_ball = false
	start_with_second_slow_ball = false
	slow_ball_bounces_off_bottom = false
	brick3_cracked_multiplier = 2
	brick0_increases_gold_multiplier = false
	powerup_gives_xp_gold_score = false

func _ready() -> void:
	var path = "res://level_ups/data/"
	var level_ups: Array = []
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open level ups folder")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = path + "/" + file_name
			var resource = load(full_path)
			level_up_id_list[file_name.left(-5)] = resource.id
		
		file_name = dir.get_next()
	#"res://level_ups/data/start_with_extra_slow_ball.tres"
	
	dir.list_dir_end()
