extends Label
var flash_colour = Color(1.0, 0.278, 0.0, 1.0)
var base_colour: Color
var base_scale: Vector2
var tween: Tween

func _ready() -> void:
	base_colour = modulate
	base_scale = scale
	pivot_offset = size / 2

func update_gold():
	self.text = ("Gold: " + str(GlobalVariables.gold))

func indicate_too_expensive():
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(self, "scale", base_scale * 1.15, 0.1)
	tween.parallel().tween_property(self, "modulate", flash_colour, 0.1)
	
	tween.tween_property(self, "scale", base_scale, 0.1)
	tween.parallel().tween_property(self, "modulate", base_colour, 0.1)
