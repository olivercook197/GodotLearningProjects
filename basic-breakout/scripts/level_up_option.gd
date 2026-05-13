@tool
extends MarginContainer

signal level_up_chosen
signal hovered
signal stopped_hovering

@export var main_texture: Texture2D:
	set(value):
		main_texture = value
		_update_texture()

func _ready():
	_update_texture()

func _update_texture():
	if not is_inside_tree():
		return
	
	var tex_rect = $Control/UpgradeItemButton/TextureRect
	if tex_rect:
		tex_rect.texture = main_texture


func _on_level_up_handler_level_up_chosen() -> void:
	level_up_chosen.emit()


func _on_hover_animator_hovered() -> void:
	hovered.emit()


func _on_hover_animator_stopped_hovering() -> void:
	stopped_hovering.emit()
