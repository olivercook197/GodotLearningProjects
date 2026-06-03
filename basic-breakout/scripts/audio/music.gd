extends AudioStreamPlayer2D
@onready var beginning_music: AudioStreamPlayer2D = $BeginningMusic

var initial_tempo = 1.0

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	play()
