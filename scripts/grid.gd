extends Control

var ubuntu_mono = preload("res://fonts/Ubuntu_Mono/UbuntuMono-Regular.ttf")

var albums = {}
var held_album = null
var selected = null

var grid_size = Vector2(5,5)
var cover_size = 150
var cover_separation = 20
var empty_cover_color = Color("0000008A")

var show_text = true
var text_color = Color.WHITE
var max_text_length = 100
var text_format = "{artist} - {album}"

var ratio = 1.0

func _draw():
	ratio = 1.0
	if get_node("/root/ui").canvas.resolution != Vector2():
		ratio = size.x / get_node("/root/ui").canvas.resolution.x
	
	var new_cover_size = cover_size * ratio
	var new_cover_separation = cover_separation * ratio
	
	selected = null
	var grid_size_in_pixels = (grid_size * new_cover_size) + ((grid_size - Vector2(1,1)) * new_cover_separation)
	
	if show_text:
		var longest_name = ""
		for album in albums.values():
			
			var n = text_format
			n = n.replace("{artist}", album.artist)
			n = n.replace("{album}", album.name)
			n = n.substr(0, max_text_length)			

			if n.length() > longest_name.length():
				longest_name = n
		var longest_size = ubuntu_mono.get_string_size(longest_name, HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
		grid_size_in_pixels.x += longest_size.x
		
		var size_inc = new_cover_size / grid_size.x
		var pos = Vector2(
			size.x / 2.0 + grid_size_in_pixels.x / 2.0 + new_cover_separation - longest_size.x, 
			size.y / 2.0 - grid_size_in_pixels.y / 2.0
		)
		for y in range(grid_size.y):
			for x in range(grid_size.x):
				if get_album(x, y).name != "":
					
					var string = text_format
					string = string.replace("{artist}", get_album(x,y).artist)
					string = string.replace("{album}", get_album(x,y).name)
					
					if string.length() > max_text_length:
						string = string.substr(0, max_text_length)
						string = string.strip_edges()
						string += "..."
					
					draw_string(
						ubuntu_mono, 
						pos + Vector2(0, size_inc * x) + Vector2(0, (new_cover_size * y) + (new_cover_separation * (y))) + Vector2(0,size_inc / 2.0) + Vector2(0,longest_size.y / 2.0), 
						string, 
						HORIZONTAL_ALIGNMENT_LEFT, 
						-1, 
						18, 
						text_color
					)
	
	for y in grid_size.y:
		for x in grid_size.x:
			var rect = Rect2(
				((x * new_cover_size) + (x * new_cover_separation) + (size.x / 2.0)) - grid_size_in_pixels.x / 2.0,
				((y * new_cover_size) + (y * new_cover_separation) + (size.y / 2.0)) - grid_size_in_pixels.y / 2.0,
				new_cover_size,
				new_cover_size
			)
			
			var mp = get_node("/root/ui").canvas.mouse_position
			if mp.x > rect.position.x - (new_cover_separation/1.9) and mp.x < rect.position.x + new_cover_size + (new_cover_separation/1.9):
				if mp.y > rect.position.y - (new_cover_separation/1.9) and mp.y < rect.position.y + new_cover_size + (new_cover_separation/1.9):
					selected = Vector2(x,y)
			
			if get_album(x,y).image != null:
				draw_texture_rect(get_album(x,y).image, rect, false)
			else:
				draw_rect(rect, empty_cover_color)

func _process(_delta): 
	queue_redraw()

func get_album(x: int, y: int) -> Album:
	if not albums.has(str(Vector2(x,y))): albums[str(Vector2(x,y))] = Album.new()
	return albums[str(Vector2(x,y))]

func set_album(x: int, y: int, album: Album):
	albums[str(Vector2(x,y))] = album

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			if selected != null and held_album != null:
				var prev_pos = held_album.previous_position
				if prev_pos != null:
					set_album(prev_pos.x, prev_pos.y, get_album(selected.x, selected.y))
					held_album.previous_position = null
				set_album(selected.x, selected.y, held_album)
			held_album = null
		
		if event.button_index == 1 and event.pressed:
			if selected != null:
				held_album = get_album(selected.x, selected.y)
				held_album.previous_position = selected
				set_album(selected.x, selected.y, Album.new())
		
		if event.button_index == 2 and event.pressed:
			if selected != null:
				set_album(selected.x, selected.y, Album.new())
