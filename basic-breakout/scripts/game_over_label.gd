extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_high_score():
	self.text = ("Out of lives!\nScore: " + str(GlobalVariables.current_score) + "\nHigh Score: " + str(GlobalVariables.high_score))
