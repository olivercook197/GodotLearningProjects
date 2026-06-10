extends AudioStreamPlayer2D

var reroll_sounds = [
	preload("res://assets/audio/effects/Reroll.mp3")
]


func play_reroll():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = reroll_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()
