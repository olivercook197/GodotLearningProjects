extends Control

@onready var label: Label = $TextureButton/Label
@onready var texture_button: TextureButton = $TextureButton

@export var action_name: String
@export var use_second_keybind: bool

var waiting_for_key := false
signal changing_controls
signal not_changing_controls

func _ready() -> void:
	set_process_unhandled_key_input(false)
	label.text = set_text_for_key(action_name, use_second_keybind)
	label.add_theme_font_size_override("font_size", 54/(0.9 + 0.1 * len(label.text)))
	pass # Replace with function body.


func set_text_for_key(action_name, use_second_keybind = false):
	var action_events = InputMap.action_get_events(action_name)
	var action_event
	if use_second_keybind:
		action_event = action_events[1]
	else:
		action_event = action_events[0]
	
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	return action_keycode



func _on_hover_animator_pressed(button) -> void:
	waiting_for_key = true
	changing_controls.emit()
	label.text = "..."
	set_process_unhandled_key_input(true)
	for i in get_tree().get_nodes_in_group("hotkey_button"):
		if i != self:
			i.texture_button.disabled = true
			
func enable_buttons():
	for i in get_tree().get_nodes_in_group("hotkey_button"):
			i.texture_button.disabled = false

func _unhandled_key_input(event: InputEvent) -> void:
	if not waiting_for_key:
		return
	
	waiting_for_key = false
	not_changing_controls.emit()
	rebind_action_key(event)
	enable_buttons()

func rebind_action_key(event) -> void:
	var events = InputMap.action_get_events(action_name)
	
	while events.size() < 2:
		events.append(null)

	if use_second_keybind:
		events[1] = event
	else:
		events[0] = event

	InputMap.action_erase_events(action_name)

	for e in events:
		if e != null:
			InputMap.action_add_event(action_name, e)

	set_process_unhandled_key_input(false)
	label.text = set_text_for_key(action_name, use_second_keybind)
	label.add_theme_font_size_override("font_size", 54/(0.9 + 0.1 * len(label.text)))
