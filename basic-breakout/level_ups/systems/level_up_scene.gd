class_name LevelUpScene 
extends Control

@export var description: String

var update_gold_label: bool = false

signal level_up_chosen
signal hovered
signal stopped_hovering

func _ready() -> void:
	for child: MarginContainer in get_children():
		child.hovered.connect(_hovered)
		child.stopped_hovering.connect(_stopped_hovering)
		child.level_up_chosen.connect(_on_level_up_option_level_up_chosen)
	on_ready()

func on_ready() -> void:
	pass

func _on_level_up_option_level_up_chosen() -> void:
	apply_level_up()
	
	level_up_chosen.emit(update_gold_label)

func apply_level_up():
	pass

func _hovered():
	hovered.emit(description)

func _stopped_hovering():
	stopped_hovering.emit()
