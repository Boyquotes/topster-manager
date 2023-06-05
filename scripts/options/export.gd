extends HBoxContainer

func _ready():
	$button.connect("pressed", func():
		$file_dialog.show()
	)
	
	$file_dialog.connect("file_selected", func(path: String):
		var img: Image = get_node("/root/ui").canvas.get_node("viewport").get_texture().get_image()
		
		if path.ends_with(".png"):
			img.save_png(path)
		elif path.ends_with(".jpg"):
			img.save_jpg(path)
		elif path.ends_with(".webp"):
			img.save_webp(path)
		else:
			img.save_png(path)
	)
