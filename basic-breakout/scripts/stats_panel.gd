extends Panel

@onready var name_label: Label = $NameLabel
@onready var value_label: Label = $ValueLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_data(stats):
	custom_minimum_size = Vector2(1324, 100)
	name_label.text = str(stats.label)
	value_label.text = str(stats.value)
	
