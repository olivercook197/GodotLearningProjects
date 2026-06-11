class_name OpenCloseAnimation
extends Node

@export var target: Control
@export var open_duration := 0.1
@export var close_duration := 0.1

var tween: Tween

func open(intended_scale = Vector2.ONE):
	if not target:
		return

	target.visible = true
	target.process_mode = Node.PROCESS_MODE_ALWAYS

	if tween:
		tween.kill()

	target.pivot_offset = target.size / 2
	target.scale = intended_scale * 0.001

	tween = target.create_tween()
	tween.tween_property(target, "scale", intended_scale, open_duration)

func close():
	if not target:
		return

	if tween:
		tween.kill()

	target.pivot_offset = target.size / 2

	tween = target.create_tween()
	tween.tween_property(
		target,
		"scale",
		Vector2.ONE * 0.001,
		close_duration
	)

	await tween.finished
	target.visible = false
