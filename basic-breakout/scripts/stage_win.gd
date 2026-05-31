extends Node2D

signal next_stage


func _on_next_stage_button_pressed() -> void:
	next_stage.emit()
