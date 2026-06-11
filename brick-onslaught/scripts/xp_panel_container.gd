extends PanelContainer

@onready var xp_label: Label = $XPLabel
func _ready() -> void:
	xp_label.update_xp()

func update_xp(animate: bool = false):
	xp_label.update_xp(animate)
