extends Node2D

var remaining_lives := 3
var high_score := 0
var current_score := 0
var gold := 0
var brick_gold_value = [1, 1, 1, 1, 1]
var brick_score_value = [1, 2, 5, 10, 20]

func score_updated(score):
	current_score = score
	if score >= high_score:
		high_score = score
