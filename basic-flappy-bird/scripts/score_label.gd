extends Label

var player_score
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound


func _ready() -> void:
	self.text = str(0)

func add_score(player_score):
	score_sound.play()
	self.text = str(player_score)
