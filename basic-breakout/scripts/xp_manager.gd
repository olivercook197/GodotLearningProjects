extends Node

const Scenes = {
	"xp_crystal": preload("uid://bsa8wwffqb71y"),
}

@onready var xp_panel_container: PanelContainer = $"../../XPPanelContainer"
@onready var xp_sound_effects: AudioStreamPlayer2D = $"../../Audio/XPSoundEffects"
@onready var powerup_manager: Node = $"../PowerupManager"

var game_scene: Node

func instantiate_xp(pos: Vector2) -> void:
	var xp = spawn(Scenes.xp_crystal, pos + Vector2(randi_range(-35, 35), randi_range(-15, 15)))
	xp.xp_collected.connect(_on_xp_collected)
	xp.add_to_group("xp")
	if powerup_manager.magnet_xp:
		xp.go_to_paddle()

func spawn(scene: PackedScene, pos := Vector2.ZERO) -> Node:
	var node = scene.instantiate()
	node.position = pos
	game_scene.add_child(node)
	return node

func _on_xp_collected(xp_collected):
	var actual_collected_xp: float = xp_collected * (1 + GlobalVariables.bonus_xp_percent) * (1 + GlobalVariables.current_score/10000.0)
	GlobalVariables.xp += actual_collected_xp
	GlobalVariables.bonus_xp += actual_collected_xp - xp_collected
	xp_panel_container.update_xp(true)
	Signals.xp_gained.emit(actual_collected_xp)
	xp_sound_effects.play_xp_collected(xp_collected)
	game_scene.balance_sounds()
