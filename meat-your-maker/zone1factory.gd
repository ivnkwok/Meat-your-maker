extends Node2D
@export var MobID = 0

enum mob {
	cow,
	lizard,
	chicken,
	crocodile
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mob.get(MobID)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
