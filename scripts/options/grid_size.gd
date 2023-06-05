extends VBoxContainer

func _ready():
	var canvas = get_node("/root/ui").canvas
	
	$width/value.text = str($width/slider.value)
	$height/value.text = str($height/slider.value)
	
	$width/slider.connect("value_changed", func(v): 
		$width/value.text = str(v)
		canvas.grid.grid_size.x = v
	)
	$height/slider.connect("value_changed", func(v): 
		$height/value.text = str(v)
		canvas.grid.grid_size.y = v
	)
	
	$width/value.connect("text_submitted", func(t):
		$width/value.release_focus()
		$width/slider.value = int(t)
		$width/value.text = str($width/slider.value)
		canvas.grid.grid_size.x = int(t)
	)
	$height/value.connect("text_submitted", func(t): 
		$height/value.release_focus()
		$height/slider.value = int(t)
		$height/value.text = str($height/slider.value)
		canvas.grid.grid_size.y = int(t)
	)

func save_to_dictionary() -> Dictionary:
	return {
		"width": $width/slider.value,
		"height": $height/slider.value,
	}

func load_from_dictionary(dict: Dictionary):
	$width/slider.value = dict.width
	$height/slider.value = dict.height
