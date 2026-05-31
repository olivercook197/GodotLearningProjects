extends AudioStreamPlayer2D
@onready var beginning_music: AudioStreamPlayer2D = $BeginningMusic

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	play()
