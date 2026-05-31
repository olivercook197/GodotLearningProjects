extends Control

@export var data: UpgradeTemplate

@onready var upgrade_item_name: Label = $UpgradeContainer/MarginContainer/VBoxContainer/UpgradeItemName
@onready var upgrade_item_gold_cost: Label = $UpgradeContainer/MarginContainer/VBoxContainer/UpgradeItemGoldCost

@onready var hover_gold_visual: HoverGoldVisual = $UpgradeContainer/MarginContainer/VBoxContainer/Control/HoverGoldVisual

@onready var button: TextureButton = $UpgradeContainer/MarginContainer/VBoxContainer/Control/UpgradeItemButton

@onready var visual: TextureRect = $UpgradeContainer/MarginContainer/VBoxContainer/Control/UpgradeItemButton/TextureRect

@onready var upgrade_handler: UpgradeHandler = $UpgradeContainer/MarginContainer/VBoxContainer/Control/UpgradeHandler


var int_gold_cost: int = 0

signal upgrade_selected(data: UpgradeTemplate, paid_cost: int)
signal upgrade_selected_too_expensive

signal hovered
signal stopped_hovering

func _ready() -> void:
	assert(data != null, "UpgradeContainer: No data assigned")
	assert(upgrade_handler != null, "UpgradeContainer: UpgradeHandler missing")
	
	upgrade_handler.data = data

	calculate_gold_costs()
	initial_ui_setting()

	upgrade_handler.upgrade_bought.connect(_on_upgrade_bought)
	hover_gold_visual.hovered.connect(_on_hover_gold_visual_hovered)
	hover_gold_visual.stopped_hovering.connect(_on_hover_gold_visual_stopped_hovering)

# --------------------
# UI setup
# --------------------

func initial_ui_setting():
	upgrade_item_name.text = data.upgrade_name
	upgrade_item_name.fit_text(upgrade_item_name.text)

	upgrade_item_gold_cost.text = str(int_gold_cost)

	if visual and data.textures.size() > 0:
		visual.texture = data.textures[0]

# --------------------
# Cost calculation
# --------------------

func calculate_gold_costs():
	var gold_cost = 1
	int_gold_cost = int(round(
		gold_cost * GlobalVariables.gold_costs[data.gold_cost] * (1 + GlobalVariables.inflation)
	))

	# pass cost into handler
	upgrade_handler.cost = int_gold_cost
	hover_gold_visual.cost = int_gold_cost

	# update UI display
	if !button.disabled:
		upgrade_item_gold_cost.text = str(int_gold_cost)
		upgrade_item_gold_cost.check_gold_against_cost(int_gold_cost)

# --------------------
# Upgrade flow
# --------------------

func _on_upgrade_bought():
	upgrade_bought_logic()
	upgrade_bought_ui_updates()
	

func upgrade_bought_logic():
	var paid_cost = int_gold_cost
	upgrade_selected.emit(data, paid_cost)
	upgrade_item_gold_cost.check_gold_against_cost(int_gold_cost)
	pass

func upgrade_bought_ui_updates():
	if data.attribute_changed != 8:
		upgrade_item_name.text = "Sold Out"
		upgrade_item_name.fit_text(upgrade_item_name.text)
		upgrade_item_gold_cost.text = ""


func _on_upgrade_handler_upgrade_clicked_too_expensive() -> void:
	upgrade_selected_too_expensive.emit()
	pass # Replace with function body.


func _on_hover_gold_visual_hovered() -> void:
	hovered.emit(int_gold_cost, data)


func _on_hover_gold_visual_stopped_hovering() -> void:
	stopped_hovering.emit()
