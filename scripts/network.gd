extends Node2D

func request(url: String) -> NetworkResponse:
	var http = HTTPRequest.new()
	http.add_user_signal("done")
	add_child(http)
	
	var response = NetworkResponse.new()
	http.connect("request_completed", func(result, code, headers, body):
		if result == -1: return
		
		response.result = result
		response.code = code
		response.headers = headers
		response.body = body
		http.emit_signal("done")
	)
	http.request(url)
	await Signal(http, "done")
	http.queue_free()
	
	# follow redirects
#	if response.code == 307:
#		url = ""
#		for header in response.headers:
#			if header.begins_with("Location: "):
#				url = header.replace("Location: ", "")
#				break
#
#		return await request(url)
	return response
