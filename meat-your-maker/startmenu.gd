extends Control

const PORT := 31419
const BINDING := "127.0.0.1"
const client_secret := "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"
const client_ID := "95347333947-30sd5b79sis0m27rq53uefppnajmdm1g.apps.googleusercontent.com"
const auth_server := "https://accounts.google.com/o/oauth2/v2/auth"
const token_req := "https://oauth2.googleapis.com/token"
const youtube_api_endpoint := "https://www.googleapis.com/youtube/v3"
const API_KEY = ApiKey.ApiKey

const SMTP_SERVER := "smtp.gmail.com"
const SMTP_PORT := 587
const SENDER_EMAIL := "your-email@gmail.com"  # Replace with your email
const SENDER_PASSWORD := "your-app-password"

var redirect_server := TCPServer.new()
var redirect_uri := "http://%s:%s" % [BINDING, PORT]
var token
var refresh_token
var user_data := {}
var is_logged_in := false

signal login_completed
signal verification_requested
signal token_recieved

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Login_Button.grab_focus()
	$VBoxContainer/Start_Button.disabled = !(is_logged_in)
	$VBoxContainer/Start_Button.modulate.a = 0.5 if $VBoxContainer/Start_Button.disabled else 1.0
	
	$VBoxContainer/Login_Button.disabled = is_logged_in
	$VBoxContainer/Login_Button.modulate.a = 0.5 if $VBoxContainer/Login_Button.disabled else 1.0
	
	create_user_interface()
	token_recieved.connect(_on_token_received)

func complete_login() -> void:
	is_logged_in = true
	$VBoxContainer/Start_Button.disabled = false
	$VBoxContainer/Start_Button.modulate.a = 1.0
	$VBoxContainer/Login_Button.disabled = true
	$VBoxContainer/Login_Button.modulate.a = 0.5
	emit_signal("login_completed")

func authorize() -> void:
	load_tokens()
	
	if !await is_token_valid():
		if !await refresh_tokens():
			get_auth_code()

func _on_token_received() -> void:
	is_logged_in = true
	$VBoxContainer/Start_Button.disabled = false
	$VBoxContainer/Start_Button.modulate.a = 1.0
	$VBoxContainer/Login_Button.disabled = true
	$VBoxContainer/Login_Button.modulate.a = 0.5

func create_user_interface() -> void:
	if !has_node("UserInfo"):
		var user_info = VBoxContainer.new()
		user_info.name = "UserInfo"
		user_info.custom_minimum_size = Vector2(200, 100)
		user_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(user_info)
		
		var profile_texture = TextureRect.new()
		profile_texture.name = "ProfilePic"
		profile_texture.custom_minimum_size = Vector2(64, 64)
		profile_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		profile_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		user_info.add_child(profile_texture)
		
		var name_label = Label.new()
		name_label.name = "UserName"
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.text = "Loading..."
		user_info.add_child(name_label)

func get_user_info() -> void:
	if !token:
		push_error("No token available")
		return
		
	var headers = PackedStringArray([
		"Authorization: Bearer %s" % token,
		"Accept: application/json"
	])
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_user_info_received)
	
	# Request user's channel information
	var url = "%s/channels?part=snippet&mine=true&key=%s" % [youtube_api_endpoint, API_KEY]
	
	var error = http_request.request(url, headers)
	if error != OK:
		push_error("Failed to request user info with error: %s" % error)

func _on_user_info_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Failed to get user info")
		return
	
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	if error != OK:
		push_error("Failed to parse response")
		return
		
	var response = json.data
	if !response or !response.has("items") or response.items.size() == 0:
		push_error("Invalid response format")
		return
	
	var channel_data = response.items[0].snippet
	user_data = {
		"name": channel_data.title,
		"description": channel_data.description,
		"profile_pic": channel_data.thumbnails.default.url
	}
	# Update UI with user data
	update_user_interface()

func update_user_interface() -> void:
	if user_data.has("name"):
		$UserInfo/UserName.text = user_data.name
	
	if user_data.has("profile_pic"):
		# Load profile picture
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_profile_pic_received)
		http_request.request(user_data.profile_pic)

func _on_profile_pic_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	
	var image = Image.new()
	# Try different image formats
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Failed to load profile picture")
		return
	
	var texture = ImageTexture.create_from_image(image)
	$UserInfo/ProfilePic.texture = texture

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
						background-color: #f0f0f0;
					}
					h1 { 
						color: #4CAF50;
						margin-bottom: 20px;
					}
					.container {
						background-color: white;
						padding: 30px;
						border-radius: 8px;
						box-shadow: 0 2px 4px rgba(0,0,0,0.1);
						max-width: 400px;
						margin: 0 auto;
					}
				</style>
			</head>
			<body>
				<div class="container">
					<h1>Authorization Successful!</h1>
					<p>You can now close this window and return to the application.</p>
				</div>
			</body>
			</html>
			"""
			
			var headers = [
				"HTTP/1.1 200 OK",
				"Content-Type: text/html",
				"Content-Length: " + str(page.length()),
				"Connection: close",
				"",
				page
			]
			
			var response = "\r\n".join(headers)
			connection.put_data(response.to_utf8_buffer())
			connection.disconnect_from_host()
			
			# After successful authentication, get user info
			await get_tree().create_timer(1.0).timeout
			get_user_info()

func get_auth_code() -> void:
	set_process(true)
	var redir_err = redirect_server.listen(PORT, BINDING)
	
	var body_parts = [
		"client_id=%s" % client_ID,
		"redirect_uri=%s" % redirect_uri,
		"response_type=code",
		"scope=https://www.googleapis.com/auth/youtube.readonly",
		"access_type=offline"
	]
	
	var url = auth_server + "?" + "&".join(body_parts)
	OS.shell_open(url)

func get_token_from_auth(auth_code: String) -> void:
	var headers = PackedStringArray([
		"Content-Type: application/x-www-form-urlencoded"
	])
	
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
	
	if response_body and response_body.has("access_token"):
		token = response_body.access_token
		if response_body.has("refresh_token"):
			refresh_token = response_body.refresh_token
		save_tokens()
		emit_signal("token_recieved")
	else:
		push_error("Failed to get access token")
	
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
	if is_logged_in:
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		var error_dialog = AcceptDialog.new()
		error_dialog.dialog_text = "Please complete login and verification first."
		add_child(error_dialog)
		error_dialog.popup_centered()

func _on_login_button_pressed() -> void:
	if !is_logged_in:
		set_process(false)
		get_auth_code()


func _on_start_button_mouse_entered() -> void:
	$VBoxContainer/Start_Button.modulate.a = .5


func _on_start_button_mouse_exited() -> void:
	$VBoxContainer/Start_Button.modulate.a = 1


func _on_login_button_mouse_entered() -> void:
	$VBoxContainer/Login_Button.modulate.a = .5


func _on_login_button_mouse_exited() -> void:
	$VBoxContainer/Login_Button.modulate.a = 1


func _on_quit_button_mouse_entered() -> void:
	$VBoxContainer/Quit_Button.modulate.a = .5


func _on_quit_button_mouse_exited() -> void:
	$VBoxContainer/Quit_Button.modulate.a = 1


func _on_quit_button_pressed() -> void:
	get_tree().quit()
