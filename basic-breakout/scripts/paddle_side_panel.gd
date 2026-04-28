@tool

class_name PaddleSidePanel extends Node2D
@export var paddle_path: NodePath

@onready var paddle: PlayerPaddle = get_node_or_null(paddle_path)
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var flip_h:bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if flip_h:
		sprite_2d.flip_h = true

func move_to_edge(paddle_size):
	var self_size = collision_shape_2d.shape.get_rect().size.x
	if sprite_2d.flip_h:
		self.position.x = paddle_size / 2 + self_size / 2
	else:
		
		self.position.x = -(paddle_size / 2 + self_size / 2)
