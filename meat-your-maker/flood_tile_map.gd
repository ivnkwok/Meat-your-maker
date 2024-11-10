extends TileMapLayer

# Called when the node enters the scene tree for the first time.
var speed = 20000
var startY = 0

func _init() -> void:
	z_index = 2
	pass # Replace with function body.
	
func _ready() -> void:
	startY = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(abs(position.y)<abs(startY)*1.01):
		position.y-=speed*delta
