extends Control

var grid:
	get:
		return get_node("viewport/root/grid")

var resolution = Vector2()
var mouse_position = Vector2()
var ratio = 1.0

var mouse_inside = false

func _ready():
	connect("mouse_entered", func(): mouse_inside = true)
	connect("mouse_exited", func(): mouse_inside = false)

func _process(_delta):
	if resolution == Vector2():
		$viewport.size = $aspect_keeper.size
		if $aspect_keeper.size.y != 0: $aspect_keeper.ratio = $aspect_keeper.size.x / $aspect_keeper.size.y
	else:
		if resolution.x > resolution.y:
			$aspect_keeper/texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		else:
			$aspect_keeper/texture.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		
		$viewport.size = resolution
		$aspect_keeper.ratio = resolution.x / resolution.y
	
	ratio = 1.0
	if resolution != Vector2():
		ratio = resolution.x / $aspect_keeper/texture.size.x
	
	mouse_position = $aspect_keeper/texture.get_local_mouse_position() * ratio
	$aspect_keeper/texture.texture = $viewport.get_texture()

func _input(event):
	if mouse_inside:
		grid._input(event)
