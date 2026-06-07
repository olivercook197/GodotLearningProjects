extends AudioStreamPlayer2D
var laser_active_sounds = [
	preload("res://assets/audio/effects/Laser Sound.mp3"),
]

var player: AudioStreamPlayer

func play_laser_active():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.add_to_group("keep_volume")
	player.bus = "Sound Effects"
	player.stream = laser_active_sounds.pick_random()
	player.finished.connect(player.queue_free)
	volume_db = -80
	player.play()
	
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0.0, 1)


func stop_audio():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, 1)
