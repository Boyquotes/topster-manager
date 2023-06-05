extends Object
class_name NetworkResponse

var result: int
var code: int
var headers: PackedStringArray
var body: PackedByteArray

func body_as_string() -> String:
	return body.get_string_from_utf8()

func body_as_json() -> Dictionary:
	var json = JSON.new()
	return json.parse_string(body_as_string())
