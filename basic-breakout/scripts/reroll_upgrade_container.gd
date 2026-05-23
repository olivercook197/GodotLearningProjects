extends PanelContainer

signal hovered
signal stopped_hovering
signal too_expensive

func _on_hover_gold_visual_hovered() -> void:
	hovered.emit(GlobalVariables.stage + 1)
	pass # Replace with function body.


func _on_hover_gold_visual_stopped_hovering() -> void:
	stopped_hovering.emit()
	pass # Replace with function body.

func _on_upgrade_handler_upgrade_clicked_too_expensive() -> void:
	too_expensive.emit()
