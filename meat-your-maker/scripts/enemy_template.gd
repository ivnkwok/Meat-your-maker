extends CharacterBody2D

class_name enemy

var state = IDLE
@onready var sprite = $AnimatedSprite2D
@export var enemyName: String = "cow"

enum {
	IDLE,
	ACTIVE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		IDLE:
			sprite.play("idle")
			pass
		ACTIVE:
			sprite.play("active")
			if (Global.playerPos.x > global_position.x):
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			global_position.x = move_toward(global_position.x, Global.playerPos.x, Global.enemyData[enemyName]["SPD"])
			global_position.y = move_toward(global_position.y, Global.playerPos.y, Global.enemyData[enemyName]["SPD"])
			print(global_position)
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	state = ACTIVE
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	state = IDLE
	pass # Replace with function body.
