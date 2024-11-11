extends Button


func _ready():
	button_down.connect(_on_Button_pressed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_Button_pressed():
	Global.playerPos = Vector2(0,0)
	Global.paused = false
	Global.playerMaxHP = 25
	Global.playerDirection = Vector2(0,0)
	Global.mobCount = 0
	Global.maxMobs = 10
	Global.meatCount = 0 #meat we have
	Global.meatPile = 0 #meat we donated
	Global.coinCount = 0
	Global.doFlood = false
	Global.knifequality = 5
	Global.hunger = 1
	Global.maxMeatPile = 0
	
	# Quit the game when the button is pressed
	get_tree().reload_current_scene()
