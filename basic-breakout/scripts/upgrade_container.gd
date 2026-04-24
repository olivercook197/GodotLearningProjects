extends PanelContainer

@export var data: UpgradeTemplate

@onready var item_name_label: Label = $MarginContainer/VBoxContainer/UpgradeItemName
@onready var gold_cost_label: Label = $MarginContainer/VBoxContainer/UpgradeItemGoldCost

@onready var button: TextureButton = $MarginContainer/VBoxContainer/Control/UpgradeItemButton
@onready var visual: TextureRect = button.get_child(0)

@onready var upgrade_handler: UpgradeHandler = $MarginContainer/VBoxContainer/Control/UpgradeHandler

var int_gold_cost: int = 0

signal upgrade_selected(data: UpgradeTemplate, paid_cost: int)
signal upgrade_selected_too_expensive

func _ready() -> void:
	assert(data != null, "UpgradeContainer: No data assigned")
	assert(upgrade_handler != null, "UpgradeContainer: UpgradeHandler missing")

	calculate_gold_costs()
	initial_ui_setting()

	upgrade_handler.upgrade_bought.connect(_on_upgrade_bought)

# --------------------
# UI setup
# --------------------

func initial_ui_setting():
	item_name_label.text = data.upgrade_name
	item_name_label.fit_text(item_name_label.text)

	gold_cost_label.text = str(int_gold_cost)

	if visual and data.textures.size() > 0:
		visual.texture = data.textures[0]

# --------------------
# Cost calculation
# --------------------

func calculate_gold_costs():
	var gold_cost = 1
	int_gold_cost = int(round(
		gold_cost * GlobalVariables.gold_costs[data.gold_cost] * GlobalVariables.inflation
	))

	# pass cost into handler (NEW WAY)
	upgrade_handler.cost = int_gold_cost

	# update UI display
	if !button.disabled:
		gold_cost_label.text = str(int_gold_cost)
		gold_cost_label.check_gold_against_cost(int_gold_cost)

# --------------------
# Upgrade flow
# --------------------

func _on_upgrade_bought():
	upgrade_bought_logic()
	upgrade_bought_ui_updates()
	

func upgrade_bought_logic():
	var paid_cost = int_gold_cost
	upgrade_selected.emit(data, paid_cost)
	gold_cost_label.check_gold_against_cost(int_gold_cost)
	pass

func upgrade_bought_ui_updates():
	item_name_label.text = "Sold Out"
	item_name_label.fit_text(item_name_label.text)
	gold_cost_label.text = ""


func _on_upgrade_handler_upgrade_clicked_too_expensive() -> void:
	upgrade_selected_too_expensive.emit()
	pass # Replace with function body.
