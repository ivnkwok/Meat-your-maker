extends CharacterBody2D

var hp = Global.playerMaxHP
@onready var sprite = $AnimatedSprite2D
@onready var hpContainer = $"HP Container"
@onready var hpBar = $"HP Container/HP Bar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#update position
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	global_position += direction * delta * 5000
	Global.playerPos = global_position
	
	#animation/turning
	print(direction)
	if (direction == Vector2(0,0)):
		sprite.play("idle")
	if (direction.x < 0 && sprite.flip_h == true):
		sprite.play("active")
		sprite.set_flip_h(false)
	if (direction.x > 0 && sprite.flip_h == false):
		sprite.play("active")
		sprite.set_flip_h(true)
	if (direction.y != 0):
		sprite.play("active")
		
	#set hp bar
	hpBar.size.x = hp/Global.playerMaxHP*(hpContainer.size.x - 2)
	
	if (hp <= 0):
		#TODO: game over screen & death
		pass
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var dmg = Global.enemyData[body.enemyName]["ATK"]
	hp -= dmg
	body.global_position.x = move_toward(body.global_position.x, Global.playerPos.x, -700)
	body.global_position.y = move_toward(body.global_position.y, Global.playerPos.y, -700)
	pass # Replace with function body.
