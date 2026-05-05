extends PanelContainer

const STATS_PANEL = preload("uid://bi8usuqall7p8")


#var stats_to_display = {"Level": {"label": "Level", "value": GlobalVariables.level}, "Happy Brick Gold": GlobalVariables.brick_gold_value[0], 
#"Happy Brick Score": GlobalVariables.brick_score_value[0], "Happy Brick Spawn Chance": GlobalVariables.brick_change_chance[0], 
#"Worried Brick Gold": GlobalVariables.brick_gold_value[1], "Worried Brick Score": GlobalVariables.brick_score_value[1], 
#"Worried Brick Spawn Chance": GlobalVariables.brick_change_chance[1], "Scared Brick Gold": GlobalVariables.brick_gold_value[2],
#"Scared Brick Score": GlobalVariables.brick_score_value[2], "Scared Brick Spawn Chance": GlobalVariables.brick_change_chance[2],
#"Angry Brick Gold": GlobalVariables.brick_gold_value[3], "Angry Brick Score": GlobalVariables.brick_score_value[3],
#"Angry Brick Spawn Chance": GlobalVariables.brick_change_chance[3], "Ball Speed": GlobalVariables.ball_speed, 
#"Paddle length": GlobalVariables.paddle_x_length, "Chance to score without increasing speed": GlobalVariables.score_without_speed, 
#"Ball Speed decrease on level start": GlobalVariables.speed_decrease_on_level_start, "Powerup Chance": GlobalVariables.powerup_chance, 
#"Gold collected at level end per 10 gold": GlobalVariables.interest, "Max Rerolls": GlobalVariables.max_rerolls, 
#"Current Score": GlobalVariables.current_score, "High Score": GlobalVariables.high_score}

var stats_to_display = {
	"Level": {"label": "Level", "value": GlobalVariables.level, "percent": false},

	"Happy Brick Gold": {"label": "Happy Brick Gold", "value": GlobalVariables.brick_gold_value[0], "percent": false},
	"Happy Brick Score": {"label": "Happy Brick Score", "value": GlobalVariables.brick_score_value[0], "percent": false},
	"Happy Brick Spawn Chance": {"label": "Happy Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[0], "percent": false},

	"Worried Brick Gold": {"label": "Worried Brick Gold", "value": GlobalVariables.brick_gold_value[1], "percent": false},
	"Worried Brick Score": {"label": "Worried Brick Score", "value": GlobalVariables.brick_score_value[1], "percent": false},
	"Worried Brick Spawn Chance": {"label": "Worried Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[1], "percent": true},

	"Scared Brick Gold": {"label": "Scared Brick Gold", "value": GlobalVariables.brick_gold_value[2], "percent": false},
	"Scared Brick Score": {"label": "Scared Brick Score", "value": GlobalVariables.brick_score_value[2], "percent": false},
	"Scared Brick Spawn Chance": {"label": "Scared Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[2], "percent": true},

	"Angry Brick Gold": {"label": "Angry Brick Gold", "value": GlobalVariables.brick_gold_value[3], "percent": false},
	"Angry Brick Score": {"label": "Angry Brick Score", "value": GlobalVariables.brick_score_value[3], "percent": false},
	"Angry Brick Spawn Chance": {"label": "Angry Brick Spawn Chance", "value": GlobalVariables.brick_change_chance[3], "percent": true},

	"Ball Speed": {"label": "Ball Speed", "value": GlobalVariables.ball_speed, "percent": false},
	"Ball Speed decrease on level start": {"label": "Ball Speed decrease on level start", "value": GlobalVariables.speed_decrease_on_level_start, "percent": false},
	
	"Paddle Length": {"label": "Paddle Length", "value": GlobalVariables.paddle_x_length, "percent": true},
	"Paddle Speed": {"label": "Paddle Speed", "value": GlobalVariables.paddle_speed, "percent": false},
	
	"Chance to score and not increase speed": {"label": "Chance to score and not increase speed", "value": GlobalVariables.score_without_speed, "percent": true},
	
	"Powerup Chance": {"label": "Powerup Chance", "value": GlobalVariables.powerup_chance, "percent": true},
	
	"Gold collected at level end per 10 gold": {"label": "Gold collected at level end per 10 gold", "value": GlobalVariables.interest, "percent": false},
	
	"Max Rerolls": {"label": "Max Rerolls", "value": GlobalVariables.max_rerolls, "percent": false},
	
	"Current Score": {"label": "Current Score", "value": GlobalVariables.current_score, "percent": false},
	
	"High Score": {"label": "High Score", "value": GlobalVariables.high_score, "percent": false}
}

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer

signal stat_menu_closed

var tween: Tween

func _ready() -> void:
	for stat in stats_to_display:
		if stats_to_display[stat].percent:
			stats_to_display[stat].value = convert_num_to_percentage(stats_to_display[stat].value)
		var menu_item = STATS_PANEL.instantiate()
		v_box_container.add_child(menu_item)
		menu_item.update_data(stats_to_display[stat])
	
	if tween:
		tween.kill()
	pivot_offset = size / 2
	scale = Vector2(0.001, 0.001)
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true

func convert_num_to_percentage(value: float):
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
