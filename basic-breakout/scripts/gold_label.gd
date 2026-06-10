extends Label
var flash_colour = Color(1.0, 0.278, 0.0, 1.0)
var preview_colour = Color(1.0, 0.9, 0.4, 0.7) # soft gold, semi-transparent
var positive_preview_colour = Color(0.659, 1.0, 0.18, 0.70)

var base_colour: Color
var base_scale: Vector2
var tween: Tween

var is_previewing := false

func _ready() -> void:
	base_colour = modulate
	base_scale = scale
	pivot_offset = size / 2

func update_gold():
	is_previewing = false
	self.text = ("Gold: " + str(int(GlobalVariables.gold)))
	animate_to(base_colour)

func indicate_too_expensive():
	var current_colour
	if is_previewing:
		current_colour = preview_colour
	else:
		current_colour = get("theme_override_colors/font_color")
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(self, "scale", base_scale * 1.15, 0.1)
	tween.parallel().tween_property(self, "modulate", flash_colour, 0.1)
	
	tween.tween_property(self, "scale", base_scale, 0.1)
	tween.parallel().tween_property(self, "modulate", current_colour, 0.1)

func indicate_future_gold(gold_cost: int, positive: bool = false):
	is_previewing = true
	#self.text = ("Gold: " + str(GlobalVariables.gold - gold_cost))
	if positive:
		text = "Gold: " + str(int(GlobalVariables.gold) + gold_cost) + " (+" + str(gold_cost) + ")"
		animate_to(positive_preview_colour)
	else:
		text = "Gold: " + str(int(GlobalVariables.gold) - gold_cost) + " (-" + str(gold_cost) + ")"
		animate_to(preview_colour)
		pass
	
	pass

func animate_to(target_color: Color):
	if tween:
		tween.kill()
	
	tween = create_tween()

	tween.tween_property(self, "modulate", target_color, 0.25)
