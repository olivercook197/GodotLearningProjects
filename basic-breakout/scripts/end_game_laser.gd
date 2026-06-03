extends Sprite2D

@onready var end_game_laser_1: AnimatedSprite2D = $EndGameLaser1
@onready var end_game_laser_2: AnimatedSprite2D = $EndGameLaser2
@onready var end_game_laser_3: AnimatedSprite2D = $EndGameLaser3
@onready var end_game_laser_4: AnimatedSprite2D = $EndGameLaser4
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

var moving
var shoot_upwards
var initial_y
var initial_x
var max_x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	initial_x = position.x
	initial_y = position.y
	sprite_2d.visible = false
	position.y += 1400
	shoot_upwards = true
	area_2d.monitoring = true
	start_animation()
	connect_signals()

func connect_signals():
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func start_animation():
	end_game_laser_1.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_2.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_3.play()
	await get_tree().create_timer(0.3).timeout
	end_game_laser_4.play()
	await get_tree().create_timer(0.3).timeout
	moving = true

func stop_animation():
	pass

func _process(delta: float) -> void:
	if moving:
		position.x += 150 * delta
	if shoot_upwards:
		if position.y <= initial_y:
			shoot_upwards = false
			sprite_2d.visible = true
		else:
			position.y -= 3000 * delta
	if max_x + initial_x <= position.x:
		moving = false
		stop_animation()




func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body is Brick:
		body.play_destruction_animation()
		pass
	print(body.get_parent().name)
	pass # Replace with function body.
