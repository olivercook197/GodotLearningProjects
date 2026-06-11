extends Node2D

signal next_stage

var pressed = false
var hovered = false

@onready var hover_animator: HoverAnimator = $PanelContainer/MarginContainer/VBoxContainer/Control/HoverAnimator
@onready var panel_container: PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/Control/VisualRoot/PanelContainer
@onready var visual_root: Control = $PanelContainer/MarginContainer/VBoxContainer/Control/VisualRoot


var tween: Tween
@onready var hover_scale = 1.15
@onready var base_scale = panel_container.scale
@onready var press_scale = 0.6
@onready var hover_colour = hover_animator.hover_colour
@onready var pressed_colour = hover_animator.pressed_colour
@onready var base_colour = panel_container.modulate
@onready var duration = hover_animator.duration


func _on_next_stage_button_pressed() -> void:
	next_stage.emit()


func _on_hover_animator_hovered() -> void:
	update_visual(false, true)
	hovered = true


func _on_hover_animator_pressed() -> void:
	pressed = true
	update_visual(true, true)


func _on_hover_animator_stopped_hovering() -> void:
	update_visual(false, false)
	hovered = false

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

func animate(target_scale: Vector2, target_color: Color):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(visual_root, "scale", target_scale, duration)
	tween.parallel().tween_property(visual_root, "modulate", target_color, duration)


func _on_texture_button_button_up() -> void:
	if pressed and hovered:
		next_stage.emit()
	else:
		pressed = false
		update_visual(false, false)
