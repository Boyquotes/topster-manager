extends HBoxContainer


func _ready():
	var canvas = get_node("/root/ui").canvas
	$options.connect("item_selected", func(i): 
		match i:
			0:
				canvas.grid.get_node("image_background").hide()
				canvas.grid.get_node("url_background").hide()
				$color.show()
				$file.hide()
				$url.hide()
			1:
				canvas.grid.get_node("image_background").show()
				canvas.grid.get_node("url_background").hide()
				$color.hide()
				$file.show()
				$url.hide()
			2:
				canvas.grid.get_node("image_background").hide()
				canvas.grid.get_node("url_background").show()
				$color.hide()
				$file.hide()
				$url.show()
	)
	
	$file/path.connect("text_submitted", load_image)
	$url/url.connect("text_submitted", load_url)
	
	$color/picker.connect("color_changed", func(c): 
		get_node("/root/ui").canvas.grid.get_node("color_background").color = c
	)

func load_image(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null: return
	
	var buffer = file.get_buffer(file.get_length())
	
	var image = Image.new()
	var result = image.load_jpg_from_buffer(buffer)
	if result != 0:
		result = image.load_png_from_buffer(buffer)
	if result != 0:
		result = image.load_webp_from_buffer(buffer)
	if result != 0:
		$file/path.text = "image failed to load."
	
	var texture = ImageTexture.create_from_image(image)
	get_node("/root/ui").canvas.grid.get_node("image_background").texture = texture

func load_url(url: String):
	var request = await Network.request(url)
	var image = Image.new()
	
	var result = image.load_jpg_from_buffer(request.body)
	if result != 0:
		result = image.load_png_from_buffer(request.body)
	if result != 0:
		result = image.load_webp_from_buffer(request.body)
	if result != 0:
		$url/url.text = "image failed to load."
	
	var texture = ImageTexture.create_from_image(image)
	get_node("/root/ui").canvas.grid.get_node("url_background").texture = texture
	$url/url.release_focus()

func save_to_dictionary() -> Dictionary:
	return {
		"selected": $options.selected,
		"color_background": { 
			"r": $color/picker.color.r,
			"g": $color/picker.color.g,
			"b": $color/picker.color.b,
			"a": $color/picker.color.a,
		},
		"image_background": $file/path.text,
		"url_background": $url/url.text
	}

func load_from_dictionary(dict: Dictionary):
	var color = dict.color_background
	$color/picker.color = Color(color.r, color.g, color.b, color.a)
	$file/path.text = dict.image_background
	$url/url.text = dict.url_background
	$options.selected = dict.selected
	
	$options.emit_signal("item_selected", $options.selected)
	$color/picker.emit_signal("color_changed", $color/picker.color)
	$file/path.emit_signal("text_submitted", $file/path.text)
	$url/url.emit_signal("text_submitted", $url/url.text)
