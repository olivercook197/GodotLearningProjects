extends Node2D

# edit when upgrades can show up in remove_upgrades() function

signal go_to_game

const upgrade_panel_scene = preload("uid://diprgck8e6i3a")	#UpgradeContainer that contains UI for buying upgrade

const BALL_SPEED_DOWN_FLAT_MEDIUM_UPGRADE = preload("uid://co6tp7m4xjxuv")
const PADDLE_MOVE_DOWN_UPGRADE = preload("uid://ckghldbmaw3rq")
const PADDLE_LENGTH_PERCENTAGE_SMALL_UPGRADE = preload("uid://t0jbcyec5707")
const SCORE_BRICK_0_SMALL_UPGRADE = preload("uid://xq4g4rwbyrc")
const GOLD_BRICK_3_SMALL_UPGRADE = preload("uid://cog0yj5t55sja")
const EXTRA_LIFE_UPGRADE = preload("uid://bc6s4qovutd6t")
const INTEREST_UPGRADE = preload("uid://byn70cyonf0ut")
const NO_SPEED_INCREASE_ON_SCORE_UPGRADE = preload("uid://bxsrp82yfmq5e")
const STATS_MENU = preload("uid://cvxqf1v5li07v")
const DARKEN_BACKGROUND = preload("uid://cy4yhp5w1mhqn")
const OPTIONS_MENU = preload("uid://cqnaxtof0tjio")


@onready var gold_label: Label = $GoldPanelContainer/GoldLabel
@onready var upgrade_container: Control = $UpgradeContainer
@onready var gold_panel_container: PanelContainer = $GoldPanelContainer
@onready var apply_upgrade: Node = $ApplyUpgrade
@onready var life_manager: Node = $LifeManager
@onready var score_panel_container: PanelContainer = $ScorePanelContainer
@onready var next_stage_button: TextureButton = $NextStageContainer/MarginContainer/Control/NextStageButton
@onready var reroll_upgrade_button: TextureButton = $RerollUpgradeContainer/MarginContainer/Control/RerollUpgradeButton
@onready var gain_life_upgrade_container: Control = $UpgradeContainer
@onready var reroll_hover_animator: HoverAnimator = $RerollUpgradeContainer/MarginContainer/Control/HoverAnimator
@onready var tooltip: PanelContainer = $TooltipPanelContainer
@onready var darken_background: Control = $DarkenBackground
@onready var options_menu: Control = $OptionsButton
@onready var gui_sound_effects: AudioStreamPlayer2D = $Audio/GUISoundEffects
@onready var audio: Audio = $Audio
@onready var shop_sound_effects: AudioStreamPlayer2D = $Audio/ShopSoundEffects



var upgrade_data_path = "res://upgrades/data/"

var upgrade_position := Vector2(-1225, -450)
var rerolls = GlobalVariables.max_rerolls
var upgrade_item_button: TextureButton


func _ready() -> void:
	print("Bonus xp gained by score: " + str(GlobalVariables.bonus_xp))
	refresh_upgrades()
	gain_life_upgrade_container.add_to_group("upgrades")
	
	score_panel_container.update_score()
	
	gold_label.update_gold()
	gold_panel_container.change_font_size()
	
	for i in GlobalVariables.max_lives:
		life_manager.add_lives_to_scene()


func _on_upgrade_item_button_pressed() -> void:
	upgrade_container.button.disabled = true

func _on_hover_animator_confirmed(button_clicked) -> void:
	if button_clicked.name == next_stage_button.name:
		if GlobalVariables.interest != 0:
			GlobalVariables.gold += int(floori(GlobalVariables.gold / 10.0) * GlobalVariables.interest)
			Signals.gold_gained.emit(int(floori(GlobalVariables.gold / 10.0) * GlobalVariables.interest))
		GlobalVariables.stage += 1
		go_to_game.emit()
	elif button_clicked.name == reroll_upgrade_button.name:
		if GlobalVariables.gold >= GlobalVariables.stage + 1:
			GlobalVariables.gold -= (GlobalVariables.stage + 1)
			gold_panel_container.update_gold()
			refresh_upgrades()
			shop_sound_effects.play_reroll()
			rerolls -= 1
			if rerolls <= 0:
				button_clicked.disabled = true
				reroll_hover_animator.disable_button()
			print("Reroll")
			Signals.rerolls.emit()
		
	pass # Replace with function body.

func _on_upgrade_container_upgrade_selected_too_expensive() -> void:
	gold_panel_container.flash()
	audio.balance_sounds()
	gui_sound_effects.play_gui_reject()
	gui_sound_effects.play_gui_not_allowed()


func _on_upgrade_container_upgrade_selected(data: UpgradeTemplate, gold_cost: int) -> void:
	GuiSoundEffects.play_chosen()
	apply_upgrade.apply_upgrade(data, gold_cost)
	GlobalVariables.inflation *= (1 + GlobalVariables.inflation_rate)
	gold_panel_container.update_gold()
	Signals.upgrades_taken.emit()
	
	for child in get_children():
		if child.is_in_group("upgrades"):
			child.calculate_gold_costs()
	if data.attribute_changed == 8 or data.attribute_changed == 5:
		life_manager.add_lives_to_scene()
	tooltip.visible = false

func _on_upgrade_container_upgrade_not_allowed():
	audio.balance_sounds()
	gui_sound_effects.play_gui_reject()

func load_all_upgrades(path: String) -> Array:
	var upgrades: Array = []
	var dir := DirAccess.open(path)

	if dir == null:
		push_error("Failed to open upgrades folder")
		return upgrades

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":

		var load_name := file_name
		
		# Convert exported filenames back to their real resource names
		if load_name.ends_with(".remap"):
			load_name = load_name.trim_suffix(".remap")

		if load_name.ends_with(".tres"):

			var resource = load(path + "/" + load_name)

			if resource is UpgradeTemplate:
				upgrades.append(resource)
			else:
				print("Not UpgradeTemplate: ", resource)

		file_name = dir.get_next()
	dir.list_dir_end()
	print("Total upgrades:", upgrades.size())
	return upgrades

func get_random_upgrades(count: int) -> Array:
	var all = load_all_upgrades(upgrade_data_path)
	all = remove_upgrades(all)
	all.shuffle()
	return all.slice(0, count)

func remove_upgrades(upgrades: Array):
	var valid_upgrades = []
	for upgrade: UpgradeTemplate in upgrades:
		if GlobalVariables.paddle_position.y >= 660 and upgrade.attribute_changed == 2:	# paddle can only go so low
			pass
		elif upgrade.attribute_changed == 1:
			if (1 + upgrade.number_change * 0.01) * GlobalVariables.paddle_x_length > 4.2:
				pass
			else:
				valid_upgrades.append(upgrade)
		elif upgrade.attribute_changed == 0:	# ball speed down only shows up if it's high enough, different value for percentage
			if upgrade.percentage == true and GlobalVariables.ball_speed < 1200:
				pass
			elif upgrade.percentage == false and GlobalVariables.ball_speed < 850:
				pass
			else:
				valid_upgrades.append(upgrade)
		elif upgrade.attribute_changed == 10 and GlobalVariables.ball_speed < 1400:	# paddle speed up only shows up if ball speed is high enough
			pass
		elif upgrade.attribute_changed == 11 and GlobalVariables.bonus_xp_percent == 0:	# bonus xp only shows up if the player has obtained a bonus xp level up
			pass
		elif upgrade.attribute_changed == 12 and LevelUpVariables.laser_burns_hotter == false:	# increasing laser threshold only shows up specific level up obtained
			pass
		else:
			valid_upgrades.append(upgrade) 
	return valid_upgrades

func refresh_upgrades():
	tooltip.visible = false
	for child in get_children():
		if child.is_in_group("upgrades_can_be_removed"):
			child.queue_free()
	var selected_upgrades = get_random_upgrades(4)
	for u in selected_upgrades.size():
		var upgrade = upgrade_panel_scene.instantiate()
		upgrade.data = selected_upgrades[u]
		add_child(upgrade)
		upgrade.upgrade_selected.connect(_on_upgrade_container_upgrade_selected)
		upgrade.upgrade_selected_too_expensive.connect(_on_upgrade_container_upgrade_selected_too_expensive)
		upgrade.upgrade_not_allowed.connect(_on_upgrade_container_upgrade_not_allowed)
		upgrade.hovered.connect(_on_hovered)
		upgrade.stopped_hovering.connect(_on_stopped_hovering)
		if u == 0:
			upgrade.position = Vector2(upgrade_position.x, upgrade_position.y)
		elif u == 1:
			upgrade.position = Vector2(upgrade_position.x + 1650, upgrade_position.y)
		elif u == 2:
			upgrade.position = Vector2(upgrade_position.x, upgrade_position.y + 580)
		elif u == 3:
			upgrade.position = Vector2(upgrade_position.x + 1650, upgrade_position.y + 580)
				
		upgrade.add_to_group("upgrades")
		upgrade.add_to_group("upgrades_can_be_removed")
	
	
func _on_hovered(gold_cost: int, upgrade_data: UpgradeTemplate = null):
	gold_panel_container.show_potential_gold(gold_cost)
	if upgrade_data != null:
		tooltip.update_text(upgrade_data.upgrade_desc)
	else:
		tooltip.update_text("Reroll options")

func _on_stopped_hovering():
	gold_panel_container.update_gold()
	tooltip.visible = false

func _on_reroll_upgrade_container_hovered(gold_cost) -> void:
	_on_hovered(gold_cost)


func _on_reroll_upgrade_container_stopped_hovering() -> void:
	gold_panel_container.update_gold()
	tooltip.visible = false


func _on_stats_panel_container_open_stats_menu() -> void:
	var stats_menu = STATS_MENU.instantiate()
	add_child(stats_menu)
	stats_menu.stat_menu_closed.connect(_stat_menu_closed)
	stats_menu.display_in_game_stats()
	stats_menu.open_panel()
	darken_background.visible = true


func _stat_menu_closed():
	darken_background.visible = false


func _on_hover_animator_hovered() -> void:
	if GlobalVariables.interest > 0:
		gold_panel_container.show_potential_gold(int(floori(GlobalVariables.gold / 10.0) * GlobalVariables.interest), true)

func _on_hover_animator_stopped_hovering() -> void:
	gold_panel_container.update_gold()


func _on_options_button_pressed() -> void:
	var dark = DARKEN_BACKGROUND.instantiate()
	add_child(dark)
	dark.add_to_group("dark_background")
	var option = OPTIONS_MENU.instantiate()
	option.process_mode = Node.PROCESS_MODE_ALWAYS
	option.process_mode = Node.PROCESS_MODE_ALWAYS
	option.scale_override = Vector2(1.4, 1.4)
	option.add_to_group("option_menu")
	option.closed.connect(_on_options_menu_closed)
	add_child(option)
	get_tree().paused = true


func _on_options_menu_closed() -> void:
	get_tree().paused = false
	for upgrade_panel in get_tree().get_nodes_in_group("upgrades"):
		upgrade_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	for i in get_tree().get_nodes_in_group("dark_background"):
		i.queue_free()
	for i in get_tree().get_nodes_in_group("option_menu"):
		i.queue_free()
