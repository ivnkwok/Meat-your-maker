extends Sprite2D

@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("cow")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	animation.play()
	if (direction.x == 0 && direction.y == 0):
		animation.stop()
	position += direction * delta * 50
	if (direction.x < 0 && scale.x < 0):
		scale.x *= -1
	if (direction.x > 0 && scale.x > 0):
		scale.x *= -1
	#if (Input.is_action_pressed("ui_up")):
		#position.y -= 1 * delta
	#if (Input.is_action_pressed("ui_down")):
		#position.y += 1 * delta
	#if (Input.is_action_pressed("ui_left")):
		#position.x -= 1 * delta
	#if (Input.is_action_pressed("ui_right")):
		#position.x += 1 * delta
	pass
