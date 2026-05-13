extends PanelContainer

@export var gold_text_size : int = 48
@onready var gold_label: Label = $GoldLabel
var tween: Tween
var too_expensive_colour = Color(1.0, 0.174, 0.127, 1.0)
var current_colour

func _ready() -> void:
	current_colour = gold_label.get_theme_color("Color")

func change_font_size():
	gold_label.add_theme_font_size_override("font_size", gold_text_size)

func update_gold():
	gold_label.update_gold()

func flash():
	gold_label.indicate_too_expensive()

func _on_upgrade_handler_upgrade_clicked_too_expensive() -> void:
	flash()

func show_potential_gold(gold_cost: int, positive: bool = false):
	gold_label.indicate_future_gold(gold_cost, positive)
