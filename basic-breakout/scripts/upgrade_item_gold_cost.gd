extends Label

var too_expensive_colour = Color(1.0, 0.174, 0.127, 1.0)
var can_afford_colour = Color(1.0, 1.0, 1.0, 1.0)
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_gold_against_cost(gold_cost):
	if GlobalVariables.gold < gold_cost:
		add_theme_color_override("font_color", too_expensive_colour)
	else:
		add_theme_color_override("font_color", can_afford_colour)

func update_gold_display_value(gold_value):
	self.text = str(gold_value)
	pass
