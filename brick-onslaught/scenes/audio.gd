class_name Audio
extends Node

func balance_sounds():
	for child in get_children():
		if child is AudioStreamPlayer2D and not child.is_in_group("keep_volume"):
			for sound in child.get_children():
				create_tween().tween_property(
					sound,
					"volume_db",
					sound.volume_db - 2,
					0.05
			)
