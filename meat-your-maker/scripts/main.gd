extends Node2D

@onready var spawnRadius = $Player/SpawnRadius/CollisionShape2D.shape.radius
@onready var noSpawnRadius = $Player/AntispawnRadius/CollisionShape2D.shape.radius

@onready var shopArea = $ShopZone/CollisionShape2D
@onready var zone1Area = $Zone1/CollisionShape2D
@onready var zone2Area = $Zone2/CollisionShape2D

@onready var attackNode = $Player/AttackNode
@onready var rotationNode = $Player/AttackNode/RotationNode
@onready var scythe = $Player/AttackNode/RotationNode/Scythe

@onready var shopGui = $ShopGUI
var swing = 1
var range = 125

var maxMobs = Global.maxMobs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scythe.position.x = range
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.maxMeatPile = max(Global.maxMeatPile, Global.meatPile)
	if (!Global.paused):
		#attack
		attackNode.look_at(get_global_mouse_position())
		if (get_local_mouse_position().distance_to(Global.playerPos) < range/2):
			scythe.position.x = abs(get_local_mouse_position().distance_to(Global.playerPos)*2)
		else:
			scythe.position.x = range
		if (rotationNode.rotation_degrees > 40 && swing > 0):
			swing = -0.03 - Global.itemUpgrades["bracers"]["Level"]/100.0
		if (rotationNode.rotation_degrees < -40 && swing < 0):
			swing = 0.03 + Global.itemUpgrades["bracers"]["Level"]/100.0
		rotationNode.rotate(swing)
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
		0:"res://chicken.tscn",
		1:"res://lizard.tscn",
		2:"res://crocodile.tscn"
	}
	if (rand < 0.5):
		mob = mobs[0]
	elif (rand < 0.9):
		mob = mobs[1]
	else:
		mob = mobs[2]
	var mobScene = load(mob)
	var spawn = mobScene.instantiate()
	spawn.position = pos
	add_child(spawn)

func zone2spawn(pos: Vector2) -> void:
	var rand = randf()
	var mob
	var mobs = {
		0:"res://chicken.tscn",
		1:"res://lizard.tscn",
		2:"res://crocodile.tscn"
	}
	if (rand < 0.5):
		mob = mobs[0]
	elif (rand < 0.9):
		mob = mobs[1]
	else:
		mob = mobs[2]
	var mobScene = load(mob)
	var spawn = mobScene.instantiate()
	spawn.position = pos
	add_child(spawn)

func _on_cave_zone_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		var shop = $ShopGUI/Shop
		Global.paused = true
		shop.visible = true
		shopGui.position = Global.playerPos
		shop.changeMakerDialogue(Global.makerDialogue[randi_range(0, Global.makerDialogue.size()-1)])
	pass # Replace with function body.
