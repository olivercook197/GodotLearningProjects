extends PanelContainer

signal open_stats_menu


func _on_hover_animator_confirmed(button) -> void:
	open_stats_menu.emit()
	print("Stat")
	pass # Replace with function body.
