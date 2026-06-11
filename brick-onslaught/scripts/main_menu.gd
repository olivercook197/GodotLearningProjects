extends Control

const STATS_MENU = preload("uid://cvxqf1v5li07v")
const OPTIONS_MENU = preload("uid://cqnaxtof0tjio")

@onready var main_menu_button_start: Control = $MainMenuButton
@onready var main_menu_button_info: Control = $MainMenuButton2
@onready var main_menu_button_stats: Control = $MainMenuButton3
@onready var texture_rect: TextureRect = $TextureRect

@onready var info_panel: Control = $InfoPanel

signal go_to_shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info_panel.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		if info_panel.visible:
			info_panel._on_hover_animator_confirmed(null)
		for stats_menu in get_tree().get_nodes_in_group("stats_menu"):
			stats_menu._on_hover_animator_confirmed(null)


func _on_main_menu_button_option_chosen(option) -> void:
	if option == 0:
		go_to_shop.emit()
		Signals.games_played.emit()
	elif option == 1:
		info_panel.open()
	elif option == 2:
		var all_time_stats_menu = STATS_MENU.instantiate()
		add_child(all_time_stats_menu)
		all_time_stats_menu.display_all_time_stats()
		all_time_stats_menu.open_panel(Vector2(0.7, 0.7), false)
		all_time_stats_menu.add_to_group("stats_menu")
		get_tree().paused = false
		
	elif option == 3:
		get_tree().quit()


func _on_options_button_pressed() -> void:
	var options_menu = OPTIONS_MENU.instantiate()
	add_child(options_menu)
