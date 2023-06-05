extends HBoxContainer

func _ready():
	$options.connect("item_selected", func(i): 
		match i:
			0:
				$width.hide()
				$height.hide()
				get_node("/root/ui").canvas.resolution = Vector2()
			1:
				$width.show()
				$height.show()
				get_node("/root/ui").canvas.resolution = Vector2(int($width.text), int($height.text))
	)
	
	$width.connect("text_submitted", func(t):
		get_node("/root/ui").canvas.resolution = Vector2(int(t), int($height.text))
	)
	
	$height.connect("text_submitted", func(t):
		get_node("/root/ui").canvas.resolution = Vector2(int($width.text), int(t))
	)

func save_to_dictionary() -> Dictionary:
	return {
		"selected": $options.selected,
		"width": $width.text,
		"height": $height.text,
	}

func load_from_dictionary(dict: Dictionary):
	$options.selected = dict.selected
	$width.text = dict.width
	$height.text = dict.height
	
	$width.emit_signal("text_submitted", $width.text)
	$height.emit_signal("text_submitted", $height.text)
	$options.emit_signal("item_selected", $options.selected)
