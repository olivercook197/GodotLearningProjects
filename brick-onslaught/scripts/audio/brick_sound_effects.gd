extends AudioStreamPlayer2D
var brick_hit_sounds = [
	preload("res://assets/audio/effects/Brick Hit1.mp3"),
	preload("res://assets/audio/effects/Brick Hit2.mp3"),
	preload("res://assets/audio/effects/Brick Hit3.mp3"),
	preload("res://assets/audio/effects/Brick Hit4.mp3"),
	preload("res://assets/audio/effects/Brick Hit5.mp3")
]

var brick_destroyed_sounds = [
	preload("res://assets/audio/effects/Brick Destroyed.mp3")
]

func play_brick_destroyed():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = brick_destroyed_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()

func play_brick_hit():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = brick_hit_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()
