extends Control
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/SFXSlider
@onready var master_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/MasterSlider
@onready var controls_panel_container: PanelContainer = $ControlsPanelContainer
@onready var open_close_animation_main_panel: OpenCloseAnimation = $OpenCloseAnimationMainPanel
@onready var open_close_animation_controls_panel: OpenCloseAnimation = $OpenCloseAnimationControlsPanel
@onready var check_box: CheckBox = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer4/CheckBox

signal closed
var choosing_keybind: = false
var scale_override: = Vector2.ONE
var control_menu_open = false

func _ready() -> void:
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	open_close_animation_main_panel.open(scale_override)
	check_box.set_block_signals(true)
	check_box.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)
	check_box.set_block_signals(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not control_menu_open:
			_on_hover_animator_confirmed(null)
		else:
			control_menu_open = false
			await open_close_animation_controls_panel.close()
			controls_panel_container.visible = false
			

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_hover_animator_confirmed(button) -> void:
	await open_close_animation_main_panel.close()
	self.visible = false
	closed.emit()


func _on_controls_button_option_chosen(option) -> void:
	controls_panel_container.visible = true
	open_close_animation_controls_panel.open()
	control_menu_open = true


func _on_change_keybind_changing_controls() -> void:
	choosing_keybind = true


func _on_change_keybind_not_changing_controls() -> void:
	choosing_keybind = false


func _on_close_button_hover_animator_confirmed(button) -> void:
	if not choosing_keybind:
		await open_close_animation_controls_panel.close()
		controls_panel_container.visible = false
		control_menu_open = false



func _on_check_box_toggled(toggled_on: bool) -> void:
	await get_tree().create_timer(0.1).timeout
	GuiSoundEffects.play_click_up()
	if DisplayServer.window_get_mode(0) == 4:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	print(DisplayServer.screen_get_size())
