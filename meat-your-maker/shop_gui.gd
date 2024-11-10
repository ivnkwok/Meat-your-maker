extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ColorRect/CoinCounter.text = ": %d" % Global.coinCount
	pass


func _on_exit_shop_button_pressed() -> void:
	Global.paused = false
	visible = false
	pass # Replace with function body.


func _on_sell_meat_button_pressed() -> void:
	Global.coinCount += Global.meatCount
	Global.meatCount = 0
	pass # Replace with function body.
