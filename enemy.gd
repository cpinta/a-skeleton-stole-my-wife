extends Entity
class_name Enemy

@export var DAMAGE := 1
@export var DAMAGES_ON_CONTACT: bool = false

@export var player : Player
@export var target : Entity
@export var FOLLOWS_PLAYER := true

@export var hurtbox : Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	player = get_tree().get_nodes_in_group("player")[0]
	
	body = $"body"
	hurtbox = body.get_node_or_null("hurtbox")
	
	if FOLLOWS_PLAYER:
		target = player
	
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 10
	
	facingDirection = Direction.LEFT
	check_direction()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if FOLLOWS_PLAYER:
		set_inputVector_toward_target()
		check_direction()
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if elementHeight.height > 25: #if flying
		#dont hit player if high up
		rb.collision_layer = 0b0001000
		rb.collision_mask = 0b1001001
		if hurtbox != null:
			hurtbox.collision_layer = 0b0001000
			hurtbox.collision_mask = 0b1001001
		pass
	else: #if on ground
		rb.collision_layer = 0b00000100
		rb.collision_mask = 0b0000111
		if hurtbox != null:
			hurtbox.collision_layer = 0b00000100
			hurtbox.collision_mask = 0b0000111
		pass
		pass
	pass
	
func check_direction():
	if facingDirection == Direction.LEFT && inputVector.x > 0:
		set_direction(Direction.RIGHT)
		
	elif facingDirection == Direction.RIGHT && inputVector.x < 0:
		set_direction(Direction.LEFT)
		
func set_inputVector_toward_target():
	inputVector = (target.global_position - global_position).normalized()
	inputVector = -Vector2(inputVector.x, inputVector.y)
		
func set_direction(dir: Direction):
	super.set_direction(dir)
	if dir == Direction.LEFT:
		#anim.flip_h = false
		body.scale.y = 1
		body.rotation = 0
	elif dir == Direction.RIGHT:
		#anim.flip_h = true
		body.scale.y = -1
		body.rotation = -PI
	pass
