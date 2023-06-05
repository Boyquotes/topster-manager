extends TextureRect

var album: Album = null:
	set(new_album):
		album = new_album
		texture = await album.load_image()
		if texture == null: queue_free()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				get_node("/root/ui").canvas.grid.held_album = album
