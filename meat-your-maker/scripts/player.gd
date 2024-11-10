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
	if (hp <= 0):
		Global.paused = true
		hpBar.visible = false
		hpContainer.visible = false
		Global.doFlood = true
	else:
		#update position
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		position += direction * delta * 50
		Global.playerDirection = direction
		Global.playerPos = position
		
		#animation/turning
		if (direction == Vector2(0,0)):
			sprite.play("idle")
		if (direction.x < 0):
			sprite.play("active")
			sprite.set_flip_h(false)
		if (direction.x > 0):
			sprite.play("active")
			sprite.set_flip_h(true)
		if (direction.y != 0):
			sprite.play("active")
			
		#set hp bar
		hpBar.size.x = (float(hp) / Global.playerMaxHP) * (hpContainer.size.x - 2)
		pass
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	var dmg = Global.enemyData[body.enemyName]["ATK"]
	hp -= dmg
	body.position.x = move_toward(body.position.x, Global.playerPos.x, -10)
	body.position.y = move_toward(body.position.y, Global.playerPos.y, -10)
	pass # Replace with function body.
