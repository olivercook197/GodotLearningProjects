extends Node2D

var current_scene
const BREAKOUT_GAME_SCENE = preload("uid://cvg3jydpl18mw")
const SHOP = preload("uid://cykrxgq8alrd2")
var shop
var game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.set_variables()
	go_to_shop()
	pass # Replace with function body.


func go_to_game():
	_switch_scene(BREAKOUT_GAME_SCENE)

func go_to_shop():
	_switch_scene(SHOP)
	pass

func _switch_scene(path):
	if current_scene:
		current_scene.queue_free()
	var scene = path.instantiate()
	add_child(scene)
	current_scene = scene
	if scene.has_signal("go_to_shop"):
		scene.go_to_shop.connect(go_to_shop)
	if scene.has_signal("go_to_game"):
		scene.go_to_game.connect(go_to_game)
