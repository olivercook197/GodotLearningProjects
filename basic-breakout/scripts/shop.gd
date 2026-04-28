extends Node2D

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



@onready var gold_label: Label = $GoldPanelContainer/GoldLabel
@onready var upgrade_item_button: TextureButton = $UpgradeContainer/MarginContainer/VBoxContainer/Control/UpgradeItemButton
@onready var gold_panel_container: PanelContainer = $GoldPanelContainer
@onready var apply_upgrade: Node = $ApplyUpgrade
@onready var life_manager: Node = $LifeManager
@onready var score_panel_container: PanelContainer = $ScorePanelContainer
@onready var next_level_button: TextureButton = $NextLevelContainer/MarginContainer/Control/NextLevelButton
@onready var reroll_upgrade_button: TextureButton = $RerollUpgradeContainer/MarginContainer/Control/RerollUpgradeButton
@onready var gain_life_upgrade_container: PanelContainer = $UpgradeContainer
@onready var reroll_hover_animator: HoverAnimator = $RerollUpgradeContainer/MarginContainer/Control/HoverAnimator

var upgrade_data_path = "res://upgrades/data/"

var upgrade_position := Vector2(-1050, -450)
var rerolls = GlobalVariables.max_rerolls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_upgrades()
	gain_life_upgrade_container.add_to_group("upgrades")
	
	score_panel_container.update_score()
	
	gold_label.update_gold()
	gold_panel_container.change_font_size()
	
	for i in GlobalVariables.max_lives:
		life_manager.add_lives_to_scene()


func _on_upgrade_item_button_pressed() -> void:
	upgrade_item_button.disabled = true
	pass # Replace with function body.

func _on_hover_animator_confirmed(button_clicked) -> void:
	if button_clicked.name == next_level_button.name:
		GlobalVariables.gold += int(floori(GlobalVariables.gold / 10.0) * GlobalVariables.interest)
		GlobalVariables.level += 1
		go_to_game.emit()
	elif button_clicked.name == reroll_upgrade_button.name:
		if GlobalVariables.gold >= GlobalVariables.level + 1:
			GlobalVariables.gold -= (GlobalVariables.level + 1)
			gold_panel_container.update_gold()
			refresh_upgrades()
			rerolls -= 1
			if rerolls <= 0:
				button_clicked.disabled = true
				reroll_hover_animator.disable_button()
			print("Reroll")
		
	pass # Replace with function body.

func _on_upgrade_container_upgrade_selected_too_expensive() -> void:
	gold_panel_container.flash()
	pass # Replace with function body.


func _on_upgrade_container_upgrade_selected(data: UpgradeTemplate, gold_cost: int) -> void:
	apply_upgrade.apply_upgrade(data)
	GlobalVariables.inflation *= GlobalVariables.inflation_rate
	gold_panel_container.update_gold()
	
	for child in get_children():
		if child.is_in_group("upgrades"):
			child.calculate_gold_costs()
	if data.attribute_changed == 8 or data.attribute_changed == 5:
		life_manager.add_lives_to_scene()

func load_all_upgrades(path: String) -> Array:
	var upgrades: Array = []
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open upgrades folder")
		return upgrades
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var resource = load(path + "/" + file_name)
			if resource is UpgradeTemplate:
				upgrades.append(resource)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return upgrades

func get_random_upgrades(count: int) -> Array:
	var all = load_all_upgrades(upgrade_data_path)
	all.shuffle()
	return all.slice(0, count)

func refresh_upgrades():
	for child in get_children():
		if child.is_in_group("upgrades_can_be_removed"):
			child.queue_free()
	var selected_upgrades = get_random_upgrades(4)
	for u in selected_upgrades.size():
		var upgrade = upgrade_panel_scene.instantiate()
		upgrade.data = selected_upgrades[u]
		upgrade.upgrade_selected.connect(_on_upgrade_container_upgrade_selected)
		upgrade.upgrade_selected_too_expensive.connect(_on_upgrade_container_upgrade_selected_too_expensive)
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
				
		add_child(upgrade)
		upgrade.add_to_group("upgrades")
		upgrade.add_to_group("upgrades_can_be_removed")
	
	
func _on_hovered(gold_cost: int):
	gold_panel_container.show_potential_gold(gold_cost)

func _on_stopped_hovering():
	gold_panel_container.update_gold()


func _on_reroll_upgrade_container_hovered(gold_cost) -> void:
	_on_hovered(gold_cost)


func _on_reroll_upgrade_container_stopped_hovering() -> void:
	gold_panel_container.update_gold()
