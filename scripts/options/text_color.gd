extends HBoxContainer

func _ready():
	$picker.connect("color_changed", func(color):
		get_node("/root/ui").canvas.grid.text_color = color
	)

func save_to_dictionary() -> Dictionary:
	return {
		"text_color": {
			"r": $picker.color.r,
			"g": $picker.color.g,
			"b": $picker.color.b,
			"a": $picker.color.a
		}
	}

func load_from_dictionary(dict: Dictionary):
	$picker.color = Color(
		dict.text_color.r, 
		dict.text_color.g,
		dict.text_color.b,
		dict.text_color.a
	)
	$picker.emit_signal("color_changed", $picker.color)
