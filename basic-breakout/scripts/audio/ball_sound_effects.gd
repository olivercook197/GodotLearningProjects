extends AudioStreamPlayer2D
var wall_hit_sounds = [
	preload("res://assets/audio/effects/Wall Hit1.mp3"),
	preload("res://assets/audio/effects/Wall Hit2.mp3"),
	preload("res://assets/audio/effects/Wall Hit3.mp3"),
	preload("res://assets/audio/effects/Wall Hit4.mp3")
]


func play_wall_hit():
	var player = AudioStreamPlayer.new()
	print("Playing")
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = wall_hit_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()
