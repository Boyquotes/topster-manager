extends HBoxContainer

func _ready():
	$width.connect("text_submitted", func(t):
		$width.release_focus()
		get_node("/root/ui").canvas.grid.max_text_length = int(t)
	)

func save_to_dictionary() -> Dictionary:
	return {
		"length": $width.text
	}

func load_from_dictionary(dict: Dictionary):
	$width.text = dict.length
	$width.emit_signal("text_submitted", $width.text)
