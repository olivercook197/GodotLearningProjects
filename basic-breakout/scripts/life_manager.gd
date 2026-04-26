extends Node

const LIVES = preload("uid://v36pc1cur2mv")

var list_of_lives := []

func add_lives_to_scene():
	list_of_lives = []
	for i in GlobalVariables.max_lives:
		instantiate_lives(Vector2(794 + 75 * i, -675))
	for life in list_of_lives:
		life.frame = 1
	for i in GlobalVariables.remaining_lives:
		var len_life_list = len(list_of_lives)
		list_of_lives[len_life_list - 1 - i].frame = 0

func instantiate_lives(pos: Vector2):
	var life := LIVES.instantiate()
	life.position = pos
	life.z_index = 50
	add_child(life)
	list_of_lives.append(life)

func remove_life():
	var finalised_life_lost = false
	for life in list_of_lives:
		if life.frame == 0:
			life.frame = 1
			GlobalVariables.remaining_lives -= 1
			break
