extends Entity
class_name Enemy

@export var DAMAGE := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 100
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
