extends Camera2D

var flooded = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.doFlood = true
	if(Global.doFlood==true): 
		if(!flooded):
			_spawn_flood()
			flooded = true
	pass


func _spawn_flood() -> void:
	var flood_scene = load("res://flood_tile_map.tscn")
	var flood = flood_scene.instantiate()
	flood.scale = Vector2(100,100)
	flood.position.y = get_viewport_rect().size.y / (scale.y/.25)
	# = (Vector2(position.x, position.y))
	self.add_child(flood)
	
