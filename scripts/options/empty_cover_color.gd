extends HBoxContainer

func _ready():
	$picker.connect("color_changed", func(c):
		get_node("/root/ui").canvas.grid.empty_cover_color = c
	)

func save_to_dictionary() -> Dictionary:
	return {
		"color": {
			"r": $picker.color.r,
			"g": $picker.color.g,
			"b": $picker.color.b,
			"a": $picker.color.a
		}
	}

func load_from_dictionary(dict: Dictionary):
	$picker.color = Color(
		dict.color.r,
		dict.color.g,
		dict.color.b,
		dict.color.a
	)
	$picker.emit_signal("color_changed", $picker.color)
