extends Control

const PORT := 31419
const BINDING := "127.0.0.1"
const client_secret := "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"
const client_ID := "95347333947-30sd5b79sis0m27rq53uefppnajmdm1g.apps.googleusercontent.com"
const auth_server := "https://accounts.google.com/o/oauth2/v2/auth"
const token_req := "https://oauth2.googleapis.com/token"

var redirect_server := TCPServer.new()
var redirect_uri := "http://%s:%s" % [BINDING, PORT]
var token
var refresh_token

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Start_Button.grab_focus()
	
func authorize() -> void:
	load_tokens()
	
	if !await is_token_valid():
		if !await refresh_tokens():
			get_auth_code()

func _process(delta: float) -> void:
	if redirect_server.is_connection_available():
		var connection = redirect_server.take_connection()
		var request = connection.get_string(connection.get_available_bytes())
		if request:
			set_process(false)
			var auth_code = request.split("&scope")[0].split("=")[1]
			
			get_token_from_auth(auth_code)
			
			var page = """
			<!DOCTYPE html>
			<html>
			<head>
				<title>Authorization Success</title>
				<style>
					body {
						font-family: Arial, sans-serif;
						text-align: center;
						padding-top: 50px;
					}
					h1 { color: #4CAF50; }
				</style>
			</head>
			<body>
			
			<h1>Success!</h1>
			<p>You may close this window!</p>
			
			</body>
			</html>
			"""
			
			# Prepare HTTP response
			var headers = [
				"HTTP/1.1 200 OK",
				"Content-Type: text/html",
				"Content-Length: " + str(page.length()),
				"Connection: close",
				"",  # Empty line to separate headers from body
				page
			]
			
			# Join headers with proper line endings and convert to PackedByteArray
			var response = "\r\n".join(headers)
			connection.put_data(response.to_utf8_buffer())
			connection.disconnect_from_host()

func get_auth_code() -> void:
	set_process(true)
	# warning-ignore:unused_variable
	var redir_err = redirect_server.listen(PORT, BINDING)
	
	var body_parts = [
		"client_id=%s" % client_ID,
		"redirect_uri=%s" % redirect_uri,
		"response_type=code",
		"scope=https://www.googleapis.com/auth/youtube.readonly",
	]
	
	var url = auth_server + "?" + "&".join(body_parts)

	# warning-ignore:return_value_discarded
	OS.shell_open(url) # Opens window for user authentication
	
func get_token_from_auth(auth_code: String) -> void:
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	headers = PackedStringArray(headers)
	
	var body_parts = [
		"code=%s" % auth_code, 
		"client_id=%s" % client_ID,
		"client_secret=%s" % client_secret,
		"redirect_uri=%s" % redirect_uri,
		"grant_type=authorization_code"
	]
	
	var body = "&".join(body_parts)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var error = http_request.request(token_req, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())

	token = response_body["access_token"]
	refresh_token = response_body["refresh_token"]
	
	save_tokens()
	emit_signal("token_recieved")
	
func refresh_tokens() -> bool:
	print("refreshing")
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	
	var body_parts = [
		"client_id=%s" % client_ID,
		"client_secret=%s" % client_secret,
		"refresh_token=%s" % refresh_token,
		"grant_type=refresh_token"
	]
	var body = "&".join(body_parts)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var error = http_request.request(token_req, headers, HTTPClient.METHOD_POST, body)

	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())
	
	if response_body.has("access_token"):
		token = response_body["access_token"]
		save_tokens()
		print("token refreshed")
		emit_signal("token_recieved")
		return true
	else:
		return false

func is_token_valid() -> bool:
	if !token:
		await get_tree().create_timer(0.001).timeout
		return false
	
	var headers = [
		"Content-Type: application/x-www-form-urlencoded"
	]
	
	var body = "access_token=%s" % token
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var error = http_request.request(token_req + "info", headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request with ERR Code: %s" % error)
	
	var response = await http_request.request_completed
	
	var response_body = JSON.parse_string(response[3].get_string_from_utf8())
	var expiration = response_body.get("expires_in")
	
	if expiration and int(expiration) > 0:
		print(expiration)
		print("token is valid")
		emit_signal("token_recieved")
		return true
	else:
		return false

# SAVE/LOAD
const SAVE_DIR = "user://token/"
var save_path = SAVE_DIR + "token.dat"

func save_tokens() -> void:
	var dir = DirAccess.open("user://")
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, 'abigail')
	if file:
		var tokens = {
			"token": token,
			"refresh_token": refresh_token
		}
		file.store_var(tokens)
		file.close()

func load_tokens() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, 'abigail')
		if file:
			var tokens = file.get_var()
			token = tokens.get("token")
			refresh_token = tokens.get("refresh_token")
			file.close()
			print("token loaded successfully")

func load_HTML(path: String) -> String:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var HTML = file.get_as_text().replace("    ", "\t").insert(0, "\n")
		file.close()
		return HTML
	return ""

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_login_button_pressed() -> void:
	set_process(false)
	get_auth_code()
