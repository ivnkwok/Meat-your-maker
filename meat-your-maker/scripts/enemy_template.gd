extends CharacterBody2D

class_name enemy

var active = true
var currentHP = 0
@onready var sprite = $AnimatedSprite2D
@onready var hitflashPlayer = $HitflashAnimationPlayer
@export var enemyName: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHP = Global.enemyData[enemyName]["MaxHP"]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (currentHP>0 && !Global.paused):
		if (Global.playerPos.distance_to(position) < 125):
			sprite.play("active")
			if (Global.playerPos.x > position.x):
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
			position.x = move_toward(position.x, Global.playerPos.x, Global.enemyData[enemyName]["SPD"]*delta)
			position.y = move_toward(position.y, Global.playerPos.y, Global.enemyData[enemyName]["SPD"]*delta)
		else: 
			sprite.play("idle")
			pass
				
		if (position.distance_to(Global.playerPos) > 300):
			Global.mobCount-=1
			queue_free()
	elif (currentHP <= 0): #dead
		spawn_meat(global_position)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemy")):
		body.position.x = move_toward(body.position.x, position.x, -5)
		body.position.y = move_toward(body.position.y, position.y, -5)
	else:
		take_damage(1)

func take_damage(amount: int):
	currentHP -= amount
	hitflashPlayer.play("hitflash")

func spawn_meat(position: Vector2) -> void:
	var meat_scene = load("res://meat.tscn")
	var spread = Global.itemUpgrades["carving knife"]["Level"] * 3
	
	for i in range(Global.itemUpgrades["carving knife"]["Level"]):
		var meat = meat_scene.instantiate()
		
		var noise_x = randf_range(-spread,spread)
		var noise_y = randf_range(-spread,spread)
		
		meat.position = (position/100) + Vector2(noise_x, noise_y)
		get_parent().add_child(meat)
		Global.mobCount -= 1
		
	queue_free()
