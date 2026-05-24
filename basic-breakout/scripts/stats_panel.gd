extends Panel

@onready var name_label: Label = $NameLabel
@onready var value_label: Label = $ValueLabel


func update_data(stats):
	custom_minimum_size = Vector2(1324, 100)
	name_label.text = str(stats.label)
	value_label.text = str(stats.value)
	
