@tool

extends Control

@export var relative_size: float = 75
@onready var texture_rect: TextureRect = $TextureButton/TextureRect

signal pressed()

func _ready() -> void:
	texture_rect.size = Vector2(relative_size, relative_size)
	texture_rect.pivot_offset = Vector2(relative_size / 2, relative_size / 2)

func _on_hover_animator_confirmed(button) -> void:
	pressed.emit()
