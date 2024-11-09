extends CharacterBody2D

var state = IDLE
@export var enemyName: String = "lizard"

enum {
	IDLE,
	ACTIVE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		IDLE:
			pass
		ACTIVE:
			if (Global.playerPos.x > position.x):
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			position.x = move_toward(position.x, Global.playerPos.x, Global.enemyData["lizard"]["SPD"])
			position.y = move_toward(position.y, Global.playerPos.y, Global.enemyData["lizard"]["SPD"])
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	state = ACTIVE
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	state = IDLE
	pass # Replace with function body.
