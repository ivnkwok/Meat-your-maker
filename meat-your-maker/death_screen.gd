extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(get_parent().hp > 0):
		for child in get_children():
			child.visible = false
	else:
		for child in get_children():
			child.visible = true
	pass
