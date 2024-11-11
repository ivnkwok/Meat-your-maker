extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CoinCounter.text = ": %d" % Global.coinCount
	$MeatCounter.text = ": %d" % Global.meatCount
	get_tree().call_group("button", "update_text")
	pass


func _on_exit_shop_button_pressed() -> void:
	Global.paused = false
	visible = false
	pass # Replace with function body.


func _on_sell_meat_button_pressed() -> void:
	changeMakerDialogue(Global.makerDialogue[randi_range(0, Global.makerDialogue.size()-1)])
	Global.coinCount += Global.meatCount
	Global.meatCount = 0
	pass # Replace with function body.

func changeMakerDialogue(text: String) -> void:
	$MakerDialogue.text = text

func _on_fulfill_quota_button_pressed() -> void:
	changeMakerDialogue("YUM YUM!!!")
	Global.meatPile += Global.meatCount
	Global.meatCount = 0
	pass # Replace with function body.


func _on_heal_button_pressed() -> void:
	changeMakerDialogue("YOU ATE MY MEAT!!!")
	if (Global.playerHP + Global.meatCount < Global.playerMaxHP):
		Global.playerHP += Global.meatCount
		Global.meatCount = 0
	else: 
		var hpDiff = Global.playerMaxHP - Global.playerHP
		Global.playerHP = Global.playerMaxHP
		Global.meatCount -= hpDiff
	pass # Replace with function body.
