extends Button


func _ready():
	button_down.connect(_on_Button_pressed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_Button_pressed():
	# Quit the game when the button is pressed
	get_tree().reload_current_scene()
