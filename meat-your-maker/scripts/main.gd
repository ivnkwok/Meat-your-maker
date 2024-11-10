extends Node2D

@onready var spawnRadius = $Player/SpawnRadius/CollisionShape2D.shape.radius * 100
@onready var noSpawnRadius = $Player/AntispawnRadius/CollisionShape2D.shape.radius * 100
@onready var attackNode = $Player/AttackNode
@onready var scythe = $Player/AttackNode/Scythe
var maxMobs = Global.maxMobs
var swing = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scythe.global_position = Vector2(noSpawnRadius/2, 0)
	for i in range(100):
		zone1spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attackNode.global_position = Global.playerPos
	print(attackNode.rotation_degrees)
	if (attackNode.rotation_degrees > 50 && swing > 0):
		swing = -0.03
	if (attackNode.rotation_degrees < -50 && swing < 0):
		swing = 0.03
	attackNode.rotate(swing)
	pass


func _on_timer_timeout() -> void:
	if(Global.mobCount<=maxMobs):
		zone1spawn()
		Global.mobCount+=1
	pass # Replace with function body.

func zone1spawn() -> void:
	var shop = $ShopZone/CollisionShape2D
	var zone1 = $Zone1/CollisionShape2D
	var zone2 = $Zone2/CollisionShape2D
	var angle = randf() * 2 * PI
	var r = randi_range(noSpawnRadius, spawnRadius)
	
	var spawnerScene = load("res://zone_1_spawner.tscn")
	var spawner = spawnerScene.instantiate()
	var x = (Global.playerPos.x + r * cos(angle))/100
	var y = (Global.playerPos.y + r * sin(angle))/100
	spawner.position = Vector2(x,y)
	print(spawner.position)
	add_child(spawner)
	
	
