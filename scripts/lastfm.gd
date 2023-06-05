extends Node

var entry = "http://ws.audioscrobbler.com/2.0/"
var api_key = "00343b857063e3112bb016e7a5c14f37"
var api_secret = "bbebcc643f3dc3703dcda73a21992225"

func search(album_name: String) -> Array:
	album_name = album_name.replace(" ", "+")
	
	var request = "http://ws.audioscrobbler.com/2.0/?method=album.search&album=%s&api_key=%s&format=json" % [album_name, api_key]
	var response: NetworkResponse = await Network.request(request)
	if response.code == 400: 
		print("Search failed.")
		return []
	
	var results = response.body_as_json()["results"]["albummatches"]["album"]
	
	var albums = []
	for r in results:
		var album = Album.new()
		album.name = r["name"]
		album.artist = r["artist"]
		album.image_url = r["image"].back()["#text"]
		albums.append(album)
	return albums
