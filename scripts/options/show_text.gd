extends HBoxContainer

func _ready():
	$value.connect("toggled", func(v): 
		get_node("/root/ui").canvas.grid.show_text = v
	)

func save_to_dictionary() -> Dictionary:
	return {
		"show": $value.button_pressed
	}

func load_from_dictionary(dict: Dictionary):
	$value.button_pressed = dict.show
	$value.emit_signal("toggled", $value.button_pressed)
