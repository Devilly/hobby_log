# Using GDScript because there is no good example of the C# version of this code
# Used docs: https://docs.godotengine.org/en/stable/classes/class_websocketpeer.html

extends Node2D

signal body_frame(data: String)
signal color_frame(data: PackedByteArray)

var color_socket = WebSocketPeer.new()
var body_socket = WebSocketPeer.new()

func _ready():
	var format_string = "ws://%s:1337/%s"
	var host = "192.168.2.81"
	
	print("WS format string: ", format_string)
	print("WS server host: ", host)
	
	color_socket.connect_to_url(format_string % [host, "color"])
	body_socket.connect_to_url(format_string % [host, "body"])

func _process(_delta):
	var color_data = process_socket(color_socket)
	if color_data:
		color_frame.emit(color_data)		
	
	var body_data = process_socket(body_socket)
	if body_data:
		body_frame.emit(body_data.get_string_from_utf8())
	
func process_socket(socket):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var payload = socket.get_packet()
			return payload
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
