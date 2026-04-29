extends PanelContainer

@onready var score_label: Label = $ScoreLabel

func update_score():
	score_label.text = ("Score: " + str(GlobalVariables.current_score))
	
