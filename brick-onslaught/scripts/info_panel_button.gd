extends Panel

enum MENU_OPTION {
	BRICKS,
	POWERUPS,
	XP,
	LASER
}

@export var option: MENU_OPTION
@onready var label: Label = $Label
@onready var hover_animator: HoverAnimator = $HoverAnimator

signal button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if option == 0:
		label.text = "Bricks"
	if option == 1:
		label.text = "Powerups"
	if option == 2:
		label.text = "XP"
	if option == 3:
		label.text = "Laser"
	


func _on_hover_animator_confirmed(button) -> void:
	button_pressed.emit(self, option)

func reset_button():
	hover_animator.free_button()
