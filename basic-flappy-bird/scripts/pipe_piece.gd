@tool
extends Node2D
class_name Pipe
signal player_died(name)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum PipeType {WHOLE, TOP, BOTTOM}
@export var pipe_type: PipeType:
	set(pipe):
		pipe_type = pipe
		if is_inside_tree():
			_on_pipe_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_pipe_changed()
	$AnimatedSprite2D/WholePipe.player_died.connect(_on_killzone_player_died)
	$AnimatedSprite2D/TopPipe.player_died.connect(_on_killzone_player_died)
	$AnimatedSprite2D/BottomPipe.player_died.connect(_on_killzone_player_died)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pipe_changed():
	$AnimatedSprite2D/WholePipe.visible = false
	$AnimatedSprite2D/WholePipe/CollisionShape2D.disabled = true
	$AnimatedSprite2D/TopPipe.visible = false
	$AnimatedSprite2D/TopPipe/CollisionShape2D.disabled = true
	$AnimatedSprite2D/BottomPipe.visible = false
	$AnimatedSprite2D/BottomPipe/CollisionShape2D.disabled = true
	if pipe_type == PipeType.WHOLE:
		animated_sprite_2d.play("pipe_body")
		show_random_frame("pipe_body")
		$AnimatedSprite2D/WholePipe.visible = true
		$AnimatedSprite2D/WholePipe/CollisionShape2D.disabled = false
	elif pipe_type == PipeType.TOP:
		animated_sprite_2d.play("pipe_top")
		show_random_frame("pipe_top")
		$AnimatedSprite2D/TopPipe.visible = true
		$AnimatedSprite2D/TopPipe/CollisionShape2D.disabled = false
	elif pipe_type == PipeType.BOTTOM:
		animated_sprite_2d.play("pipe_bottom")
		show_random_frame("pipe_bottom")
		$AnimatedSprite2D/BottomPipe.visible = true
		$AnimatedSprite2D/BottomPipe/CollisionShape2D.disabled = false

func show_random_frame(animation:String) -> void:
	animated_sprite_2d.animation = animation
	var frame_count = animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation)
	animated_sprite_2d.frame = randi_range(0, frame_count)

func _on_killzone_player_died(name):
	player_died.emit(name)
