extends Node

signal open_menu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		open_menu.emit()
