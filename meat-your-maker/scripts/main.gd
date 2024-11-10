extends Node2D

@onready var spawnRadius = $Player/SpawnRadius/CollisionShape2D.shape.radius
@onready var noSpawnRadius = $Player/AntispawnRadius/CollisionShape2D.shape.radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_timer_timeout() -> void:
	zone1spawn()
	pass # Replace with function body.

func zone1spawn() -> void:
	var shop = $ShopZone/CollisionShape2D
	var zone1 = $Zone1/CollisionShape2D
	var zone2 = $Zone2/CollisionShape2D
	var angle = randf() * 2 * PI
	var r = randi_range(noSpawnRadius, spawnRadius) * sqrt(randf())
	
	var spawnerScene = load("res://zone_1_spawner.tscn")
	var spawner = spawnerScene.instantiate()
	print(spawner)
	var x = (Global.playerPos.x + (r * cos(angle)))
	var y = (Global.playerPos.y + r * sin(angle))
	spawner.position = Vector2(x,y) - Global.playerPos
	add_child(spawner)
	
	print(spawner.global_position)
	print(Global.playerPos)
	
	
