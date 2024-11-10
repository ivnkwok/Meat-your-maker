extends CharacterBody2D

class_name enemy

var state = IDLE
var currentHP = 0
@onready var sprite = $AnimatedSprite2D
@export var enemyName: String = ""

enum {
	IDLE,
	ACTIVE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHP = Global.enemyData[enemyName]["MaxHP"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(position)
	if(currentHP>0):
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
				global_position.x = move_toward(position.x, Global.playerPos.x, Global.enemyData[enemyName]["SPD"])
				global_position.y = move_toward(position.y, Global.playerPos.y, Global.enemyData[enemyName]["SPD"])
				
		if (global_position.distance_to(Global.playerPos) > 350*100):
			Global.mobCount-=1
			queue_free()
	else: #dead
		spawn_meat(global_position)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	state = ACTIVE
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	state = IDLE
	pass # Replace with function body.
	
func spawn_meat(position: Vector2) -> void:
	var meat_scene = load("res://meat.tscn")
	var meat = meat_scene.instantiate()
	meat.position = position/100
	print("spawned meat at:", meat.position)
	get_parent().add_child(meat)
	Global.mobCount-=1
	queue_free()
