extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@onready var hpContainer = $"HP Container"
@onready var hpBar = $"HP Container/HP Bar"

@onready var meatTimer = $MeatTimer
@onready var meatContainer = $MeatBarContainer
@onready var meatBar = $MeatBarContainer/MeatBar



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.doFlood = false
	sprite.play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.playerHP <= 0 || Global.doFlood):
		Global.playerHP = 0
		Global.paused = true
		meatBar.visible = false
		meatContainer.visible = false
		sprite.visible = false
		hpBar.visible = false
		hpContainer.visible = false
	elif (!Global.paused):
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
		Global.playerMaxHP += Global.itemUpgrades["armor"]["Level"]
		hpBar.size.x = (float(Global.playerHP) / Global.playerMaxHP) * (hpContainer.size.x - 2)
		pass
	meatBar.size.x = (float(Global.meatPile) / Global.maxMeatPile) * (meatContainer.size.x - 2)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var dmg = Global.enemyData[body.enemyName]["ATK"]
	Global.playerHP -= dmg
	body.position.x = move_toward(body.position.x, Global.playerPos.x, -10)
	body.position.y = move_toward(body.position.y, Global.playerPos.y, -10)
	pass # Replace with function body.

func _on_meat_timer_timeout() -> void:
	Global.meatPile-=1
	if (Global.meatPile <= 0):
		Global.doFlood = true
	print(Global.meatPile, "/", Global.maxMeatPile, ",",meatTimer.wait_time)
	
	meatTimer.wait_time *= 0.95
	meatTimer.start()
	
	pass # Replace with function body.
