extends Node2D

const GROUND = preload("uid://crgknxdifkp6x")
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var initial_draw_x = -48
	var draw_y = 48
	for i in 8:
		var instance = GROUND.instantiate()
		$".".add_child(instance)
		instance.set_position(Vector2(initial_draw_x + i * 16, draw_y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var children = get_children(false)
	for child in children:
		if child is Ground:
			child.position.x -= 0.75
	pass


func _on_killzone_player_died() -> void:
	player.player_died()
	pass # Replace with function body.
