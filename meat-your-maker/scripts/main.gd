extends Node2D

@onready var spawnRadius = $Player/SpawnRadius/CollisionShape2D.shape.radius
@onready var noSpawnRadius = $Player/AntispawnRadius/CollisionShape2D.shape.radius

@onready var shopArea = $ShopZone/CollisionShape2D
@onready var zone1Area = $Zone1/CollisionShape2D
@onready var zone2Area = $Zone2/CollisionShape2D

@onready var attackNode = $Player/AttackNode
@onready var scythe = $Player/AttackNode/Scythe
var swing = 1

var maxMobs = Global.maxMobs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scythe.position = Vector2(noSpawnRadius, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attackNode.position = Global.playerPos
	print(attackNode.rotation_degrees)
	if (attackNode.rotation_degrees > 50 && swing > 0):
		swing = -0.03
	if (attackNode.rotation_degrees < -50 && swing < 0):
		swing = 0.03
	attackNode.rotate(swing)
	pass


func _on_timer_timeout() -> void:
	if(Global.mobCount<=maxMobs):
		trySpawn()
		Global.mobCount+=1
	pass # Replace with function body.

func trySpawn() -> void:
	var angle = randf() * 2 * PI
	var r = randi_range(noSpawnRadius, spawnRadius)
	var x = (Global.playerPos.x + r * cos(angle))
	var y = (Global.playerPos.y + r * sin(angle))
	var pos = Vector2(x,y)
	
	if (Geometry2D.is_point_in_polygon(pos, shopArea.polygon)):
		#trySpawn()
		return
	elif (Geometry2D.is_point_in_polygon(pos, zone1Area.polygon)):
		zone1spawn(pos)
	elif (Geometry2D.is_point_in_polygon(pos, zone2Area.polygon)):
		pass

func zone1spawn(pos: Vector2) -> void:
	var rand = randf()
	var mob
	var mobs = {
		0:"res://cow.tscn",
		1:"res://chicken.tscn",
		2:"res://lizard.tscn",
		3:"res://crocodile.tscn"
	}
	if (rand < 0.3):
		mob = mobs[0]
	elif (rand < 0.6):
		mob = mobs[1]
	elif (rand < 0.9):
		mob = mobs[2]
	else:
		mob = mobs[3]
	var mobScene = load(mob)
	var spawn = mobScene.instantiate()
	spawn.position = pos
	add_child(spawn)
	
	
