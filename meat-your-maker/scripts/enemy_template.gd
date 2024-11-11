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
	if(currentHP>0):
		match state:
			IDLE:
				sprite.play("idle")
				pass
			ACTIVE:
				sprite.play("active")
				if (Global.playerPos.x > position.x):
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
				position.x = move_toward(position.x, Global.playerPos.x, Global.enemyData[enemyName]["SPD"]*delta)
				position.y = move_toward(position.y, Global.playerPos.y, Global.enemyData[enemyName]["SPD"]*delta)
				
		if (position.distance_to(Global.playerPos) > 300):
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
	var spread = Global.knifequality*3
	for i in range(Global.knifequality):
		var meat = meat_scene.instantiate()
		
		var noise_x = randf_range(-spread,spread)
		var noise_y = randf_range(-spread,spread)
		
		meat.position = (position/100) + Vector2(noise_x, noise_y)
		get_parent().add_child(meat)
		Global.mobCount-=1
		
	queue_free()
