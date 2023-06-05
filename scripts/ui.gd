extends Control

var canvas:
	get:
		return get_node("split/canvas")

func _draw():
	if canvas.grid.held_album != null:
		var s = Vector2(canvas.grid.cover_size, canvas.grid.cover_size) * (1.0 / canvas.ratio)
		var rect = Rect2(get_local_mouse_position() - s / 2.0, s)
		if canvas.grid.held_album.image != null:
			draw_texture_rect(canvas.grid.held_album.image, rect, false)
		else:
			draw_rect(rect, get_node("/root/ui").canvas.grid.empty_cover_color)

func _process(_delta): queue_redraw()
