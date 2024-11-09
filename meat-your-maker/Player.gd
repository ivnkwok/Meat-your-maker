extends CharacterBody2D

var hp = Global.playerMaxHP
@onready var sprite = $AnimatedSprite2D
@onready var hpContainer = $"HP Container"
@onready var hpBar = $"HP Container/HP Bar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#update position
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	position += direction * delta * 50
	Global.playerPos = position
	
	#animation/turning
	sprite.play("cow")
	if (direction.x == 0 && direction.y == 0):
		sprite.stop()
	if (direction.x < 0 && sprite.flip_h == true):
		sprite.set_flip_h(false)
	if (direction.x > 0 && sprite.flip_h == false):
		sprite.set_flip_h(true)
		
	#set hp bar
	hpBar.size.x = hp/Global.playerMaxHP*(hpContainer.size.x - 2)
	
	if (hp <= 0):
		#TODO: game over screen & death
		pass
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var dmg = Global.enemyData[body.enemyName]["ATK"]
	hp -= dmg
	body.position.x = move_toward(body.position.x, Global.playerPos.x, -15)
	body.position.y = move_toward(body.position.y, Global.playerPos.y, -15)
	pass # Replace with function body.
