extends Button

func _on_pressed():
	Global.init()
	get_tree().reload_current_scene()
	
