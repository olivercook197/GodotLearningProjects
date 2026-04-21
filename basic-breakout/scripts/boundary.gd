extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

signal player_colliding


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	pass
	#move_and_slide()




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_position_and_size(rect: Rect2):
	position = rect.position
	
	var shape = RectangleShape2D.new()
	shape.size = rect.size
	$BoundaryCollisionShape2D.shape = shape
	
	if shape is RectangleShape2D:
		shape.size = rect.size

	var tiles_wide = int(rect.size[0]/16)
	var tiles_tall = int(rect.size[1]/16)
	#print(str(tiles_tall) + ", " + str(tiles_wide))
	
	for i in tiles_wide + 1:
		for j in tiles_tall:
			$TileMapLayer.set_cell(Vector2(-tiles_wide / 2 - 1 + i,-tiles_tall / 2 + j), 
			0, Vector2(i % 3, j % 3))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerPaddle:
		player_colliding.emit()
	if body is Ball:
		pass
