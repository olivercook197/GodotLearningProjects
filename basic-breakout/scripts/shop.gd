extends Node2D

signal go_to_game

const upgrade_panel_scene = preload("uid://diprgck8e6i3a")	#UpgradeContainer that contains UI for buying upgrade

const BALL_SPEED_DOWN_FLAT_MEDIUM_UPGRADE = preload("uid://co6tp7m4xjxuv")
const PADDLE_MOVE_DOWN_UPGRADE = preload("uid://ckghldbmaw3rq")
const PADDLE_LENGTH_PERCENTAGE_SMALL_UPGRADE = preload("uid://t0jbcyec5707")



@onready var gold_label: Label = $GoldPanelContainer/GoldLabel
@onready var upgrade_item_button: TextureButton = $UpgradeContainer/MarginContainer/VBoxContainer/Control/UpgradeItemButton
@onready var gold_panel_container: PanelContainer = $GoldPanelContainer
@onready var apply_upgrade: Node = $ApplyUpgrade


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var upgrade = upgrade_panel_scene.instantiate()
	upgrade.data = PADDLE_MOVE_DOWN_UPGRADE
	upgrade.upgrade_selected.connect(_upgrade_selected)
	upgrade.upgrade_selected_too_expensive.connect(_upgrade_selected_too_expensive)
	upgrade.upgrade_selected.connect(_on_upgrade_selected)
	add_child(upgrade)
	upgrade.add_to_group("upgrades")
	
	upgrade = upgrade_panel_scene.instantiate()
	upgrade.data = PADDLE_LENGTH_PERCENTAGE_SMALL_UPGRADE
	upgrade.upgrade_selected.connect(_upgrade_selected)
	upgrade.upgrade_selected_too_expensive.connect(_upgrade_selected_too_expensive)
	upgrade.upgrade_selected.connect(_on_upgrade_selected)
	upgrade.position.x = 600
	add_child(upgrade)
	upgrade.add_to_group("upgrades")
	
	gold_label.update_gold()
	gold_panel_container.change_font_size()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_upgrade_item_button_pressed() -> void:
	upgrade_item_button.disabled = true
	pass # Replace with function body.

func _upgrade_selected(data: UpgradeTemplate, gold_cost: int) -> void:
	GlobalVariables.inflation *= GlobalVariables.inflation_rate
	gold_panel_container.update_gold()
	
	for child in get_children():
		if child.is_in_group("upgrades"):
			child.calculate_gold_costs()
			
	pass

func _upgrade_selected_too_expensive() -> void:
	gold_panel_container.flash()
	pass


func _on_hover_animator_confirmed() -> void:
	go_to_game.emit()
	pass # Replace with function body.

func _on_upgrade_selected(data: UpgradeTemplate, cost: int):
	apply_upgrade.apply_upgrade(data)
	pass
