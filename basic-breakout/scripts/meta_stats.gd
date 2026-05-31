extends Node

const SAVE_PATH = "user://meta_stats.save"
const GAMES_PLAYED = "games_played"
const GOLD_EARNED = "gold_earned"
const BRICKS_DESTROYED = "bricks_destroyed"
const POWERUPS_COLLECTED = "powerups_collected"
const XP_GAINED = "xp_gained"
const MOST_XP_GAINED = "most_xp_gained"
const LEVEL_UPS_TAKEN = "level_ups_taken"
const UPGRADES_TAKEN = "upgrades_taken"
const LIVES_LOST = "lives_lost"
const REROLLS = "rerolls"
const HIGHEST_STAGE = "highest_stage"


var lifetime_stats := {
	GAMES_PLAYED: 0,
	GOLD_EARNED: 0,
	BRICKS_DESTROYED: 0,
	POWERUPS_COLLECTED: 0,
	XP_GAINED: 0,
	MOST_XP_GAINED: 0,
	LEVEL_UPS_TAKEN: 0,
	UPGRADES_TAKEN: 0,
	LIVES_LOST: 0,
	REROLLS: 0,
	HIGHEST_STAGE: 0
}

var current_run_stats := {
	GAMES_PLAYED: 0,
	GOLD_EARNED: 0,
	BRICKS_DESTROYED: 0,
	POWERUPS_COLLECTED: 0,
	XP_GAINED: 0,
	MOST_XP_GAINED: 0,
	LEVEL_UPS_TAKEN: 0,
	UPGRADES_TAKEN: 0,
	LIVES_LOST: 0,
	REROLLS: 0,
	HIGHEST_STAGE: 0
}

func _ready() -> void:
	load_stats()
	reset_current_stats()
	Signals.games_played.connect(_games_played)
	Signals.gold_gained.connect(on_gold_gained)
	Signals.brick_destroyed.connect(_on_brick_destroyed)
	Signals.powerup_collected.connect(_on_powerup_collected)
	Signals.xp_gained.connect(_on_xp_gained)
	Signals.level_ups_taken.connect(_level_ups_taken)
	Signals.upgrades_taken.connect(_upgrades_taken)
	Signals.lives_lost.connect(_on_life_lost)
	Signals.rerolls.connect(_on_reroll)
	Signals.game_over.connect(_game_over)
	
func _games_played():
	add_stat_current_run(GAMES_PLAYED)

func on_gold_gained(amount_gained):
	add_stat_current_run(GOLD_EARNED, amount_gained)

func _on_brick_destroyed():
	add_stat_current_run(BRICKS_DESTROYED)

func _on_powerup_collected():
	add_stat_current_run(POWERUPS_COLLECTED)

func _on_xp_gained(amount_gained):
	add_stat_current_run(XP_GAINED, amount_gained)

func _level_ups_taken():
	add_stat_current_run(LEVEL_UPS_TAKEN)

func _upgrades_taken():
	add_stat_current_run(UPGRADES_TAKEN)

func _on_life_lost():
	add_stat_current_run(LIVES_LOST)

func _on_reroll():
	add_stat_current_run(REROLLS)


func _game_over():
	add_stat_current_run(MOST_XP_GAINED, current_run_stats[XP_GAINED])
	add_stat_current_run(HIGHEST_STAGE, GlobalVariables.stage)
	add_run_stats_to_main_stats()
	reset_current_stats()
	save_stats()

func add_run_stats_to_main_stats():
	for global_stat in lifetime_stats:
		if global_stat == MOST_XP_GAINED or global_stat == HIGHEST_STAGE:
			pass
		else:
			lifetime_stats[global_stat] += current_run_stats[global_stat]
	pass

func save_stats():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(lifetime_stats))

func load_stats():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text = file.get_as_text()
	
	lifetime_stats = JSON.parse_string(text)

func add_stat_current_run(stat, number_added: float = 1.0):
	current_run_stats[stat] += number_added

func reset_current_stats():
	current_run_stats = {
	GAMES_PLAYED: 0,
	GOLD_EARNED: 0,
	BRICKS_DESTROYED: 0,
	POWERUPS_COLLECTED: 0,
	XP_GAINED: 0,
	MOST_XP_GAINED: 0,
	LEVEL_UPS_TAKEN: 0,
	UPGRADES_TAKEN: 0,
	LIVES_LOST: 0,
	REROLLS: 0,
	HIGHEST_STAGE: 0
}
