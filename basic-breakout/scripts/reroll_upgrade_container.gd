extends PanelContainer

signal hovered
signal stopped_hovering

func _on_hover_gold_visual_hovered() -> void:
	hovered.emit(GlobalVariables.level + 1)
	pass # Replace with function body.


func _on_hover_gold_visual_stopped_hovering() -> void:
	stopped_hovering.emit()
	pass # Replace with function body.
