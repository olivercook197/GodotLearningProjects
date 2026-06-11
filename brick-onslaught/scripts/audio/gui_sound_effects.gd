extends AudioStreamPlayer2D
var gui_reject_sounds = [
	preload("res://assets/audio/effects/GUI Reject.mp3"),
]

var gui_not_allowed = [
	preload("res://assets/audio/effects/GUI Not Allowed.mp3")
]

var gui_click_down_sounds = [
	preload("res://assets/audio/effects/Click Down.mp3")
]

var gui_click_up_sounds = [
	preload("res://assets/audio/effects/Click Up.mp3")
]

var gui_chosen_sounds = [
	preload("res://assets/audio/effects/GUI Chosen.mp3")
]

var player: AudioStreamPlayer

func play_gui_reject():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = gui_reject_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()

func play_gui_not_allowed():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.stream = gui_not_allowed.pick_random()
	player.finished.connect(player.queue_free)
	player.play()

func play_click_down():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.add_to_group("keep_volume")
	player.stream = gui_click_down_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()

func play_click_up():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	player.add_to_group("keep_volume")
	player.stream = gui_click_up_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()

func play_chosen():
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Sound Effects"
	#player.add_to_group("keep_volume")
	player.stream = gui_chosen_sounds.pick_random()
	player.finished.connect(player.queue_free)
	player.play()
