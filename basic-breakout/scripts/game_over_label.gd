extends Label


func display_high_score():
	self.text = ("Out of lives!\nScore: " + str(GlobalVariables.current_score) + "\nHigh Score: " + str(GlobalVariables.high_score))
