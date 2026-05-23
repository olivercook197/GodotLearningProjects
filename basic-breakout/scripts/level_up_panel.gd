extends Panel

@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer3/HBoxContainer

var num_level_up_options: int
var level_up_data_path = "res://level_ups/data/"

signal level_up_chosen
signal level_up_hovered
signal level_up_stopped_hovering

# Called when the node enters the scene tree for the first time.
func activate() -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	
	num_level_up_options = GlobalVariables.level_up_options
	var level_up_choices = choose_level_up_options(num_level_up_options)
	
	if num_level_up_options == 3:
		h_box_container.add_theme_constant_override("separation", 500)
	elif num_level_up_options == 4:
		h_box_container.add_theme_constant_override("separation", 400)
	elif num_level_up_options == 5:
		h_box_container.add_theme_constant_override("separation", 315)
	else:
		h_box_container.add_theme_constant_override("separation", 300)
	
	for option: LevelUpOption in level_up_choices:
		var level_up_choice = option.modifier_scene.instantiate()
		level_up_choice.level_up_chosen.connect(_level_up_chosen)
		level_up_choice.hovered.connect(_hovered)
		level_up_choice.stopped_hovering.connect(_stopped_hovering)
		
		h_box_container.add_child(level_up_choice)

func _level_up_chosen(update_gold_panel: bool, gold_gained: int = 0):
	print("Level up chosen")
	level_up_chosen.emit(update_gold_panel, gold_gained)
	Signals.level_ups_taken.emit()

func _hovered(tooltip: String):
	level_up_hovered.emit(tooltip)

func _stopped_hovering():
	level_up_stopped_hovering.emit()

func choose_level_up_options(count: int) -> Array:
	var all = load_all_level_ups(level_up_data_path)
	all.shuffle()
	return all.slice(0, count)

func load_all_level_ups(path: String) -> Array:
	var level_ups: Array = []
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Failed to open level ups folder")
		return level_ups
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = path + "/" + file_name
			var resource = load(full_path)
			var add_level_up = true
			if resource is LevelUpOption:
				if resource.one_time:	# don't add one time level ups
					if LevelUpVariables.taken_level_ups.has(resource.id):
						add_level_up = false
				if resource.stat_requirements_to_unlock:	# only add level ups that meet the minimum requirement
					print(resource.get_stat_value(resource.stat_requirements_to_unlock[0]))
					if resource.get_stat_value(resource.stat_requirements_to_unlock[0]) <= resource.requirement_minimum:
						add_level_up = false
				if resource.levelup_requirements_to_unlock:	# only add level ups that have prerequisite levelup
					var lookup = 0
					for i in resource.levelup_requirements_to_unlock:
						if resource.get_levelup_option(resource.levelup_requirements_to_unlock[lookup]) not in LevelUpVariables.taken_level_ups:
							add_level_up = false
						lookup += 1
					
				if add_level_up:
					level_ups.append(resource)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return level_ups
