extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (float(Global.meatPile)/Global.maxMeatPile < 0.25 || Global.meatPile <= 1):
		visible = true
	else:
		visible = false
	pass
