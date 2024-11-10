extends Node2D
@export var MobID = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mobs = {
		0:$Cow,
		1:$Chicken,
		2:$Lizard,
		3:$Crocodile
	}
	var rand = randf()
	if (rand < 0.3):
		MobID = 0
	elif (rand < 0.6):
		MobID = 1
	elif (rand < 0.9):
		MobID = 2
	else:
		MobID = 3
	for i in range(mobs.size()):
		if (i != MobID):
			mobs[i].free()
	pass # Replace with function body.
