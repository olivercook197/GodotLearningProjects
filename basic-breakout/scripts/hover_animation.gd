extends Node
class_name HoverAnimator

# check Button Path, Visual Path and Button Has Requirements in Inspector
@export var hover_scale: float = 1.15
@export var press_scale: float = 1.0
@export var hover_color: Color = Color(1, 1, 1)
@export var pressed_color: Color = Color(0.7, 0.7, 0.7)
@export var duration: float = 0.12
@export var normal_texture: Texture2D
@export var disabled_texture: Texture2D

@export var button_path: NodePath	# set in Inspector
@export var visual_path: NodePath	# set in Inspector

@export var button_has_requirements_to_press: bool = false	# check this

@onready var button: BaseButton = get_node_or_null(button_path)
@onready var visual: Control = get_node_or_null(visual_path)

var base_scale: Vector2
var base_color: Color

var tween: Tween
var tween_rotation: Tween

var is_pressed := false
var is_hovered := false
var is_disabled := false

signal pressed   # user clicked
signal confirmed

func _ready():
	assert(button != null, "HoverAnimator: button_path invalid")	# set in Inspector
	assert(visual != null, "HoverAnimator: visual_path invalid")	# set in Inspector

	base_scale = visual.scale
	base_color = visual.modulate
	visual.pivot_offset = button.size / 2

	if visual is TextureRect and normal_texture:
		visual.texture = normal_texture

	_connect_signals()

func _connect_signals():
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)

func _on_mouse_entered():
	if is_disabled: 
		return
	is_hovered = true
	update_visual()

func _on_mouse_exited():
	if is_disabled: 
		return
	is_hovered = false
	update_visual()

func _on_button_down():
	if is_disabled: 
		return
	if button_has_requirements_to_press:
		# let external logic decide
		pressed.emit()
	else:
		# behave like a normal button
		is_pressed = true
		update_visual()

func _on_button_up():
	if not is_pressed:
		return
	
	is_pressed = false
	update_visual()
	
	if is_hovered:
		confirmed.emit()

func reject_press():
	is_pressed = false
	reset_rotation()
	animate(base_scale * hover_scale if is_hovered else base_scale, hover_color if is_hovered else base_color)
	animate_shake()

func accept_press():
	is_pressed = true
	update_visual()

# --------------------
# Visual control only
# --------------------

func update_visual():
	if is_disabled:
		animate(base_scale, base_color)
		return
	
	reset_rotation()

	if is_pressed:
		if is_hovered:
			animate(base_scale * press_scale, pressed_color)
		else:
			animate(base_scale, pressed_color)
	else:
		if is_hovered:
			animate(base_scale * hover_scale, hover_color)
		else:
			animate(base_scale, base_color)

func animate(target_scale: Vector2, target_color: Color):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(visual, "scale", target_scale, duration)
	tween.parallel().tween_property(visual, "modulate", target_color, duration)

func animate_shake(max_rotation: float = 20, tween_duration: float = 0.4):
	if tween_rotation:
		tween_rotation.kill()

	tween_rotation = create_tween()

	var current_rotation = visual.rotation_degrees
	var steps = 8
	var time_per_step = tween_duration / steps
	var amplitude = max_rotation

	for i in range(steps):
		var direction = -1 if i % 2 == 0 else 1

		tween_rotation.tween_property(
			visual,
			"rotation_degrees",
			current_rotation + amplitude * direction,
			time_per_step
		)

		amplitude *= 0.6

	tween_rotation.tween_property(
		visual,
		"rotation_degrees",
		current_rotation,
		time_per_step
	)

func reset_rotation():
	if tween_rotation:
		tween_rotation.kill()
	visual.rotation_degrees = 0

# --------------------
# External control API
# --------------------

func disable_button():
	is_disabled = true
	button.disabled = true
	if visual is TextureRect and disabled_texture:
		visual.texture = disabled_texture
	update_visual()
