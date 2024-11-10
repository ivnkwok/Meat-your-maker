extends Node2D

@onready var spawnRadius = $Player/SpawnRadius/CollisionShape2D.shape.radius * 100
@onready var noSpawnRadius = $Player/AntispawnRadius/CollisionShape2D.shape.radius * 100
@onready var shopArea = $ShopZone/CollisionShape2D
@onready var zone1Area = $Zone1/CollisionShape2D
@onready var zone2Area = $Zone2/CollisionShape2D

enum {
	shop,
	zone1,
	zone2,
	zone3
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _on_timer_timeout() -> void:
	trySpawn()
	pass # Replace with function body.

func trySpawn() -> void:
	var angle = randf() * 2 * PI
	var r = randi_range(noSpawnRadius, spawnRadius)
	var x = (Global.playerPos.x + r * cos(angle))/100
	var y = (Global.playerPos.y + r * sin(angle))/100
	var pos = Vector2(x,y)
	
	
	if (Geometry2D.is_point_in_polygon(pos, shopArea.polygon)):
		trySpawn()
		return
	elif (Geometry2D.is_point_in_polygon(pos, zone1Area.polygon)):
		zone1spawn(pos)
	elif (Geometry2D.is_point_in_polygon(pos, zone2Area.polygon)):
		pass

func zone1spawn(pos: Vector2) -> void:
	var spawnerScene = load("res://zone_1_spawner.tscn")
	var spawner = spawnerScene.instantiate()

	spawner.global_position = pos
	add_child(spawner)
	
	
