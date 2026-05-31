extends Control

@onready var confirmation_window: PanelContainer = $MainMenuConfirmationWindow
@onready var button: Button = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Button
@onready var label: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Title/Label
@onready var game_over_label: Label = $PanelContainer/MarginContainer/VBoxContainer/VBoxGameOver/GameOverLabel
@onready var v_box_game_over: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/VBoxGameOver
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var close_button: Panel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var exit_game_confirmation_window: PanelContainer = $ExitGameConfirmationWindow
@onready var open_close_animation: OpenCloseAnimation = $OpenCloseAnimation

var game_over = false
var confirmation_window_open = false

signal close
signal go_to_menu
signal go_to_shop
signal open_options

func _ready() -> void:
	confirmation_window.visible = false
	exit_game_confirmation_window.visible = false
	v_box_game_over.visible = false
	open_close_animation.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !game_over:
			try_to_close_menu()

func game_over_panel():
	game_over = true
	v_box_game_over.visible = true
	close_button.visible = false
	button.text = "Play Again"
	label.text = "Game Over!"
	game_over_label.text = ("Out of lives!\nScore: " + str(int(GlobalVariables.current_score)) + "\nHigh Score: " + str(GlobalVariables.high_score))


func _on_hover_animator_confirmed(button) -> void:
	try_to_close_menu()


func _on_button_pressed() -> void:
	if game_over:
		go_to_shop.emit(true)
	else:
		try_to_close_menu()

func try_to_close_menu():
	close.emit()

func close_menu():
	await open_close_animation.close()
	queue_free()

func _on_button_2_pressed() -> void:
	if !confirmation_window_open:
		if !game_over:
			confirmation_window.visible = true
			confirmation_window_open = true
		else:
			go_to_menu.emit()

func _on_button_3_pressed() -> void:
	if !confirmation_window_open:
		exit_game_confirmation_window.visible = true
		confirmation_window_open = true
		if game_over:
			$ExitGameConfirmationWindow/MarginContainer/VBoxContainer/Label.text = "Are you sure you want to exit the game?"
		else:
			$ExitGameConfirmationWindow/MarginContainer/VBoxContainer/Label.text = "Are you sure you want to exit the game? All progress will be lost."

func _on_confirmation_yes_button_pressed() -> void:
	get_tree().paused = false
	go_to_menu.emit()


func _on_confirmation_no_button_pressed() -> void:
	confirmation_window.visible = false
	confirmation_window_open = false


func _on_exit_game_confirmation_yes_button_pressed() -> void:
	go_to_menu.emit()
	get_tree().quit()



func _on_exit_game_confirmation_no_button_pressed() -> void:
	exit_game_confirmation_window.visible = false
	confirmation_window_open = false


func _on_options_button_pressed() -> void:
	open_options.emit()
