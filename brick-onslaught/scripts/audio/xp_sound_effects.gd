extends AudioStreamPlayer2D

var xp_colected_sounds = [
	preload("res://assets/audio/effects/XP Collected.mp3"),
	preload("res://assets/audio/effects/XP Collected2.mp3"),
	preload("res://assets/audio/effects/XP Collected3.mp3")
]

var xp_colected_value_sounds = [
	preload("res://assets/audio/effects/XP Collected Size.mp3")
]

func play_xp_collected(xp_value):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = xp_colected_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.volume_db = linear_to_db(randf_range(0.9, 1.0))
	player.play()
	var player2 = AudioStreamPlayer.new()
	add_child(player2)
	player2.bus = "Sound Effects"
	player2.volume_db = linear_to_db(xp_value / 9.0 + 0.1)
	player2.stream = xp_colected_value_sounds.pick_random()
	player2.finished.connect(player2.queue_free)
	player2.play()
