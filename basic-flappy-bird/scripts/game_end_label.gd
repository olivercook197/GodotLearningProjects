extends Label


func player_died(score, high_score):
	self.text = ("Score: " + str(score) + "\nHigh Score: " + str(high_score))
