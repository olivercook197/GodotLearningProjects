extends Label

var base_colour: Color
var base_scale: Vector2
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_colour = modulate
	base_scale = scale
	pivot_offset = size / 2
	pass # Replace with function body.

func update_xp(animate: bool = false):
	if GlobalVariables.xp >= GlobalVariables.xp_level_cap:
		GlobalVariables.xp_level += 1
		GlobalVariables.xp -= GlobalVariables.xp_level_cap
		GlobalVariables.xp_level_cap += (GlobalVariables.xp_level - 1) * 25
		GlobalVariables.levels_gained += 1
	text = ("XP: " + str(int(GlobalVariables.xp)) + "/" + str(GlobalVariables.xp_level_cap))
	if animate:
		animate_xp_gain()

func animate_xp_gain():
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	tween.tween_property(self, "scale", base_scale * 1.15, 0.1)
	
	tween.tween_property(self, "scale", base_scale, 0.1)
