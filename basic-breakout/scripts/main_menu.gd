extends Control

@onready var main_menu_button_start: Control = $MainMenuButton
@onready var main_menu_button_info: Control = $MainMenuButton2
@onready var main_menu_button_stats: Control = $MainMenuButton3

@onready var info_panel: Control = $InfoPanel

signal go_to_shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_panel.visible = false
	pass # Replace with function body.



func _on_main_menu_button_option_chosen(option) -> void:
	print(option)
	if option == 0:
		go_to_shop.emit()
		Signals.games_played.emit()
	if option == 1:
		info_panel.open()
