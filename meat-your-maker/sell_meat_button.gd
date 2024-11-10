extends Button

@onready var shopArea = get_tree().root.get_node("/root/main/ShopZone").get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_Button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Geometry2D.is_point_in_polygon(Global.playerPos, shopArea.polygon)):
		visible = true
	else:
		visible = false
	pass

func _on_Button_pressed():
	# Quit the game when the button is pressed
	Global.meatPile += Global.meatCount
	Global.meatCount = 0
