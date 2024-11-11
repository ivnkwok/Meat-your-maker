extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "You Died!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.doFlood):
		text = "Flooded! You did not meat your quota!"
	pass
