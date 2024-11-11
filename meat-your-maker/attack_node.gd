extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(Global.itemUpgrades["sword"]["Level"])
	pass # Replace with function body.
