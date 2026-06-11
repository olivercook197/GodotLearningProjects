class_name LevelUpScene 
extends Control

@export var description: String
@export var id: int	# must be the same as the resource ID

var update_gold_label: bool = false
var gold_gained: int = 0

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
	LevelUpVariables.taken_level_ups[id] = true
	if id not in MetaStats.current_run_stats[MetaStats.UNIQUE_LEVEL_UPS_TAKEN]:
		MetaStats.current_run_stats[MetaStats.UNIQUE_LEVEL_UPS_TAKEN].append(id)
	
	level_up_chosen.emit(update_gold_label, gold_gained)

func apply_level_up():
	pass

func _hovered():
	hovered.emit(description)

func _stopped_hovering():
	stopped_hovering.emit()
