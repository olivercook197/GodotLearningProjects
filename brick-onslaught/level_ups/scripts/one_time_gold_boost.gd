extends LevelUpScene

var gained_gold = 50 + (GlobalVariables.xp_level - GlobalVariables.levels_gained - 1) * 25

func on_ready() -> void:
	description = str("Gain " + str(gained_gold) + " Gold")
	update_gold_label = true
	gold_gained = gained_gold

func apply_level_up():
	GlobalVariables.gold += gained_gold
