extends Node2D
class_name WholePipe
signal player_died(name)
signal player_scored

const PIPE_PIECE = preload("uid://bvuwd0b16xlo6")
const POINT_SCORE_COLLISION = preload("uid://cj12qwi7w6b2a")

var initial_draw_y: int = 0
var second_draw_y: int = -118

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 7:
		var instance = PIPE_PIECE.instantiate()
		if i == 0:
			instance.pipe_type = Pipe.PipeType.TOP
		else:
			instance.pipe_type = Pipe.PipeType.WHOLE
		$".".add_child(instance)
		instance.set_position(Vector2(0, initial_draw_y + i * 16))
	
	for i in 6:
		var instance = PIPE_PIECE.instantiate()
		if i == 5:
			instance.pipe_type = Pipe.PipeType.BOTTOM
		else:
			instance.pipe_type = Pipe.PipeType.WHOLE
		$".".add_child(instance)
		instance.set_position(Vector2(0, second_draw_y + i * 16))
	
	var point_score = POINT_SCORE_COLLISION.instantiate()
	$".".add_child(point_score)
	point_score.set_position(Vector2(6, 0))
	
	for pipe in get_children():
		if pipe.has_signal("player_died"):
			pipe.player_died.connect(_on_pipe_piece_died)
		elif pipe.has_signal("player_scored"):
			pipe.player_scored.connect(_on_point_score_collision_player_scored)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x < -48:
		position.x = 71
		change_y_pos()
	
func change_y_pos() -> void:
	position.y = randi_range(-31, 42)

func _on_pipe_piece_died(name):
	player_died.emit(name)
	
func _on_point_score_collision_player_scored():
	player_scored.emit()
	pass
