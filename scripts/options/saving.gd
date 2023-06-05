extends HBoxContainer

@onready
var canvas = get_node("/root/ui").canvas

enum Mode { SAVE, LOAD }
var mode = Mode.SAVE

func _ready():
	$save_button.connect("pressed", func():
		mode = Mode.SAVE
		$file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		$file_dialog.title = "save :D"
		$file_dialog.show()
	)
	
	$load_button.connect("pressed", func():
		mode = Mode.LOAD
		$file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		$file_dialog.title = "load :o"
		$file_dialog.show()
	)
	
	$file_dialog.connect("file_selected", func(path: String):
		match mode:
			Mode.SAVE:
				save_grid(path)
				
			Mode.LOAD:
				load_grid(path)
	)

func save_grid(path: String):
	#if not path.ends_with(".json"): path += ".json"
	
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var json = JSON.new()
	
	var save_dict = {}
	
	# album saving
	var albums = []
	for pos in canvas.grid.albums.keys():
		var dict = canvas.grid.albums[pos].save()
		dict["position"] = pos
		albums.append(dict)
	
	save_dict["albums"] = albums
	
	# for each option, save it and add it to the dict
	for option in get_parent().get_children():
		if option.has_method("save_to_dictionary"):
			save_dict[option.name] = option.save_to_dictionary()
	
	# stringify the dict and save it
	var save_string = json.stringify(save_dict, "\t")
	save_file.store_string(save_string)

func load_grid(path: String):
	var save_file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var save_string = save_file.get_as_text()
	json.parse(save_string)
	var save_dict = json.get_data()
	
	# album loading
	for album in save_dict["albums"]:
		var pos = album.position
		
		canvas.grid.albums[pos] = Album.new()
		canvas.grid.albums[pos].name = album.name
		canvas.grid.albums[pos].artist = album.artist
		canvas.grid.albums[pos].image_url = album.image_url 
		canvas.grid.albums[pos].load_image(true)
	
	for option in get_parent().get_children():
		if save_dict.has(option.name) and option.has_method("load_from_dictionary"):
			option.load_from_dictionary(save_dict[option.name])
