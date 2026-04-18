extends Area2D

signal player_scored

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	player_scored.emit()
