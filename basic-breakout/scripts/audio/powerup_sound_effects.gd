extends AudioStreamPlayer2D
var gain_powerup_sounds = [
	preload("res://assets/audio/effects/Powerup Sound.mp3"),
]

func play_gain_powerup():
	var player = AudioStreamPlayer.new()
	print("Playing")
	add_child(player)
	player.add_to_group("keep_volume")
	player.bus = "Sound Effects"
	player.stream = gain_powerup_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()
