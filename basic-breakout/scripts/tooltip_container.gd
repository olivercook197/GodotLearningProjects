extends PanelContainer

@onready var label: Label = $MarginContainer/Label
var on_the_left : bool
var on_the_top : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	label.custom_minimum_size = Vector2(500, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		var mouse_position = get_global_mouse_position()
		var offset := Vector2.ZERO
		if on_the_left:
			offset.x = 10
		else:
			offset.x = -size.x - 10
		if on_the_top:
			offset.y = 10
		else:
			offset.y = -size.y - 10
		
		position = mouse_position + offset

func update_text(description: String):
	var screen_size = get_viewport_rect().size
	var mouse_pos = get_global_mouse_position()

	on_the_left = mouse_pos.x < 150
	on_the_top = mouse_pos.y < 150
	
	label.text = description
	
	# Clear any previous minimum constraints
	label.custom_minimum_size = Vector2(500, 0)

	# Force recalculation
	label.reset_size()
	reset_size()
	
	await get_tree().process_frame
	
	visible = true
	
