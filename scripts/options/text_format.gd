extends HBoxContainer

func _ready():
	$format.connect("text_submitted", func(t):
		get_node("/root/ui").canvas.grid.text_format = t
	)

func save_to_dictionary() -> Dictionary:
	return {
		"format": $format.text
	}

func load_from_dictionary(dict: Dictionary):
	$format.text = dict.format
	$format.emit_signal("text_submitted", $format.text)
