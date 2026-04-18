extends Area2D

signal player_died

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("You died by " + self.name)
	print(body, " | name:", body.name, " | type:", body.get_class())
	Engine.time_scale = 0.35
	player_died.emit(name)
	body.get_node("CollisionShape2D").queue_free()
	timer.start()



func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
