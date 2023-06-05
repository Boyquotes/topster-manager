extends VBoxContainer

var cover_scn = preload("res://scenes/cover.tscn")
@onready var grid = $album_search/scroll_container/margin_container/album_search_grid
var current_query = ""

func _ready():
	$search_button.connect("pressed", func():
		current_query = $album_line_edit.text
		search()
	)
	
	$album_line_edit.connect("text_submitted", func(t):
		current_query = t
		search()
	)

func search():
	var query = current_query
	for cover in grid.get_children():
		cover.queue_free()
	
	var albums = await LastFM.search(query)
	for album in albums:
		var cover = cover_scn.instantiate()
		cover.album = album
		if query == current_query:
			grid.add_child(cover)
