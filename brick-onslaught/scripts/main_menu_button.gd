@tool
extends Control

@export var main_texture: Texture2D:
	set(value):
		main_texture = value
		_update_texture()

enum OPTION {
	START,
	INFO,
	STATS,
	EXIT
}

@export var option: OPTION

@onready var hover_animator: HoverAnimator = $HoverAnimator
@onready var panel_container: PanelContainer = $VisualRoot/PanelContainer
@onready var visual_root: Control = $VisualRoot

var tween: Tween
@onready var hover_scale = 1.15
@onready var base_scale = panel_container.scale
@onready var press_scale = 0.6
@onready var hover_colour = hover_animator.hover_colour
@onready var pressed_colour = hover_animator.pressed_colour
@onready var base_colour = panel_container.modulate
@onready var duration = hover_animator.duration

var pressed = false
var hovered = false

signal option_chosen

func _ready() -> void:
	
	$VisualRoot/PanelContainer/TextureButton.button_up.connect(_on_button_up)
	$TextureButton.button_up.connect(_on_button_up)
	_update_texture()
	

func _update_texture():
	if not is_inside_tree():
		return
	
	var tex_rect = $VisualRoot/PanelContainer/TextureButton/TextureRect
	if tex_rect:
		tex_rect.texture = main_texture


func _on_hover_animator_hovered() -> void:
	update_visual(false, true)
	hovered = true


func _on_hover_animator_stopped_hovering() -> void:
	update_visual(false, false)
	hovered = false

func _on_hover_animator_pressed() -> void:
	pressed = true
	update_visual(true, true)


func update_visual(is_pressed: bool = false, is_hovered: bool = false):
	if is_pressed:
		if is_hovered:
			animate(base_scale * press_scale, pressed_colour)
		else:
			if pressed:
				animate(base_scale * press_scale, pressed_colour)
			else:
				animate(base_scale, pressed_colour)
	else:
		if is_hovered:
			if pressed:
				animate(base_scale * press_scale, pressed_colour)
			else:
				animate(base_scale * hover_scale, hover_colour)
		else:
			if pressed:
				animate(base_scale, pressed_colour)
			else:
				animate(base_scale, base_colour)

func _on_button_up():
	if not pressed:
		return
	
	pressed = false
	update_visual()


func animate(target_scale: Vector2, target_color: Color):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(visual_root, "scale", target_scale, duration)
	tween.parallel().tween_property(visual_root, "modulate", target_color, duration)

func _on_texture_button_mouse_entered() -> void:
	update_visual(false, true)

func _on_texture_button_mouse_exited() -> void:
	update_visual(false, true)


func _on_texture_button_button_up() -> void:
	if pressed and hovered:
		option_chosen.emit(option)
