class_name Album

var name: String
var artist: String
var image_url: String
var previous_position = null

var image = null
func load_image(reload = false):
		if (image == null or reload) and image_url != "":
			image = await fetch_image()
		return image

func fetch_image():
	var img = Image.new()
	var request = await Network.request(image_url)
	if img.load_png_from_buffer(request.body) != 0: return null
	
	image = ImageTexture.create_from_image(img)
	return image

func save():
	return {
		"name": name,
		"artist": artist,
		"image_url": image_url,
	}
