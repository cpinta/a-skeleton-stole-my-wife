extends Entity
class_name Enemy

@export var DAMAGE := 1

@export var player : Player
@export var target : Entity
@export var FOLLOWS_PLAYER := true

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	rb.collision_mask = 3
	
	player = get_tree().get_nodes_in_group("player")[0]
	
	if FOLLOWS_PLAYER:
		target = player
	
	
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 10
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if FOLLOWS_PLAYER:
		inputVector = (target.global_position() - global_position()).normalized()
		inputVector = -Vector2(inputVector.x, inputVector.y)
		if Direction.LEFT && inputVector.x > 0:
			set_direction(Direction.RIGHT)
		elif Direction.RIGHT && inputVector.x < 0:
			set_direction(Direction.LEFT)
	pass

func _physics_process(delta):
	super._physics_process(delta)
	pass
