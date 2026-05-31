extends Control

@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer
@onready var brick_scroll_container: ScrollContainer = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/BrickScrollContainer
@onready var powerup_scroll_container: ScrollContainer = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/PowerupScrollContainer
@onready var xp_scroll_container: ScrollContainer = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/XPScrollContainer
@onready var open_close_animation: OpenCloseAnimation = $OpenCloseAnimation


var tween: Tween
var hovered
var pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	brick_scroll_container.visible = false
	powerup_scroll_container.visible = false
	xp_scroll_container.visible = false
	
	open_close_animation.open()



func _on_info_panel_button_button_pressed(info_button_pressed, option) -> void:
	for info_panel_button in v_box_container.get_children():
		if info_panel_button != info_button_pressed:
			info_panel_button.reset_button()
	brick_scroll_container.visible = false
	powerup_scroll_container.visible = false
	xp_scroll_container.visible = false
	if option == 0:
		brick_scroll_container.set_deferred("scroll_vertical", 0)
		brick_scroll_container.visible = true
	elif option == 1:
		powerup_scroll_container.set_deferred("scroll_vertical", 0)
		powerup_scroll_container.visible = true
	elif option == 2:
		xp_scroll_container.set_deferred("scroll_vertical", 0)
		xp_scroll_container.visible = true
		

func open():
	self.visible = true
		
	if tween:
		tween.kill()
	pivot_offset = size / 2
	scale = Vector2(0.001, 0.001)
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func close_animation():
	if tween:
		tween.kill()
	pivot_offset = size / 2
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.001, 0.001), 0.1)

func _on_hover_animator_confirmed(button) -> void:
	open_close_animation.close()
