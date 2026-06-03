# controls how the data in the stats panel is presented, and its opening and closing animations
# needs updating when new stats are added

extends PanelContainer

const STATS_PANEL = preload("uid://bi8usuqall7p8")

var stats_to_display_in_game = {
	"Stage": {"label": "Stage", "value": GlobalVariables.stage, "percent": false},
	
	"Level": {"label": "Level", "value": GlobalVariables.xp_level, "percent": false},

	"Happy Brick Gold": {"label": "Happy Brick Gold", "value": GlobalVariables.brick_gold_value[0], "percent": false},
	"Happy Brick Score": {"label": "Happy Brick Score", "value": GlobalVariables.brick_score_value[0], "percent": false},
	"Happy Brick Spawn Chance": {"label": "Happy Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[0], "percent": true, "alter_percent": true},

	"Worried Brick Gold": {"label": "Worried Brick Gold", "value": GlobalVariables.brick_gold_value[1], "percent": false},
	"Worried Brick Score": {"label": "Worried Brick Score", "value": GlobalVariables.brick_score_value[1], "percent": false},
	"Worried Brick Spawn Chance": {"label": "Worried Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[1], "percent": true, "alter_percent": true},

	"Scared Brick Gold": {"label": "Scared Brick Gold", "value": GlobalVariables.brick_gold_value[2], "percent": false},
	"Scared Brick Score": {"label": "Scared Brick Score", "value": GlobalVariables.brick_score_value[2], "percent": false},
	"Scared Brick Spawn Chance": {"label": "Scared Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[2], "percent": true, "alter_percent": true},

	"Angry Brick Gold": {"label": "Angry Brick Gold", "value": GlobalVariables.brick_gold_value[3], "percent": false},
	"Angry Brick Score": {"label": "Angry Brick Score", "value": GlobalVariables.brick_score_value[3], "percent": false},
	"Angry Brick Spawn Chance": {"label": "Angry Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[3], "percent": true, "alter_percent": true},

	"Ball Speed": {"label": "Ball Speed", "value": GlobalVariables.ball_speed, "percent": false},
	"Ball Speed decrease on stage start": {"label": "Ball Speed decrease on stage start", "value": GlobalVariables.speed_decrease_on_stage_start, "percent": false},
	
	"Paddle Length": {"label": "Paddle Length", "value": GlobalVariables.paddle_x_length, "percent": true},
	"Paddle Speed": {"label": "Paddle Speed", "value": GlobalVariables.paddle_speed, "percent": false},
	
	"Chance to score and not increase speed": {"label": "Chance to score and not increase speed", "value": GlobalVariables.score_without_speed, "percent": true},
	
	"Powerup Chance": {"label": "Powerup Chance", "value": GlobalVariables.powerup_chance, "percent": true},
	
	"Inflation multiplier per purchase": {"label": "Inflation increase per purchase", "value": GlobalVariables.inflation_rate, "percent": true},
	"Interest per 10 gold": {"label": "Interest per 10 gold", "value": GlobalVariables.interest, "percent": false},
	
	"Max Rerolls": {"label": "Max Rerolls", "value": GlobalVariables.max_rerolls, "percent": false},
	
	"Current Score": {"label": "Current Score", "value": GlobalVariables.current_score, "percent": false},
	
	"High Score": {"label": "High Score", "value": GlobalVariables.high_score, "percent": false}
}


var stats_to_display_all_time = {
	"Games Played": {"label": "Games Played", "value": MetaStats.lifetime_stats[MetaStats.GAMES_PLAYED], "percent": false},
	
	"Gold Gained": {"label": "Gold Gained", "value": MetaStats.lifetime_stats[MetaStats.GOLD_EARNED], "percent": false},

	"Bricks Destroyed": {"label": "Bricks Destroyed", "value": MetaStats.lifetime_stats[MetaStats.BRICKS_DESTROYED], "percent": false},
	"Powerups Collected": {"label": "Powerups Collected", "value": MetaStats.lifetime_stats[MetaStats.POWERUPS_COLLECTED], "percent": false},
	"XP Gained": {"label": "XP Gained", "value": MetaStats.lifetime_stats[MetaStats.XP_GAINED], "percent": false},

	"Level Ups Taken": {"label": "Level Ups Taken", "value": MetaStats.lifetime_stats[MetaStats.LEVEL_UPS_TAKEN], "percent": false},
	"Upgrades Taken": {"label": "Upgrades Taken", "value": MetaStats.lifetime_stats[MetaStats.UPGRADES_TAKEN], "percent": false},
	"Lives Lost": {"label": "Lives Lost", "value": MetaStats.lifetime_stats[MetaStats.LIVES_LOST], "percent": false},

	"Total Rerolls": {"label": "Total Rerolls", "value": MetaStats.lifetime_stats[MetaStats.REROLLS], "percent": false},
}


@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer

signal stat_menu_closed

var tween: Tween


func display_in_game_stats():
	add_extra_stats()
	
	for stat in stats_to_display_in_game:
		if stats_to_display_in_game[stat].percent:
			stats_to_display_in_game[stat].value = convert_num_to_percentage(stats_to_display_in_game[stat].value, stats_to_display_in_game[stat].get("alter_percent", false))
		else:
			stats_to_display_in_game[stat].value = int(stats_to_display_in_game[stat].value)
		var menu_item = STATS_PANEL.instantiate()
		v_box_container.add_child(menu_item)
		menu_item.update_data(stats_to_display_in_game[stat])

func display_all_time_stats():
	for stat in stats_to_display_all_time:
		if stats_to_display_all_time[stat].percent:
			stats_to_display_all_time[stat].value = convert_num_to_percentage(stats_to_display_all_time[stat].value, stats_to_display_all_time[stat].get("alter_percent", false))
		else:
			stats_to_display_all_time[stat].value = int(stats_to_display_all_time[stat].value)
		var menu_item = STATS_PANEL.instantiate()
		v_box_container.add_child(menu_item)
		menu_item.update_data(stats_to_display_all_time[stat])

func open_panel(max_scale = Vector2(1, 1), pause = true):
	if tween:
		tween.kill()
	pivot_offset = size / 2
	scale = Vector2(0.001, 0.001)
	tween = create_tween()
	tween.tween_property(self, "scale", max_scale, 0.1)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	await get_tree().create_timer(0.12).timeout
	
	if pause:
		get_tree().paused = true

func convert_num_to_percentage(value: float, alter_percent: bool = false):
	if alter_percent:
		return str(str(int(snapped(value, 1))) + "%")
	else:
		return str(str(int(snapped(value, 0.01) * 100)) + "%")


func _on_hover_animator_confirmed(button) -> void:
	close_animation()
	stat_menu_closed.emit()
	get_tree().paused = false

func close_animation():
	if tween:
		tween.kill()
	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.001, 0.001), 0.1)
	
	await tween.finished
	
	queue_free()

func add_extra_stats():
	if GlobalVariables.bonus_xp_percent > 0:
		stats_to_display_in_game.set("Bonus Xp Gain", {"label": "Bonus Xp Gain", "value": GlobalVariables.bonus_xp_percent, "percent": true})
	pass
