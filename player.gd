extends Entity
class_name Player

var lineMouseAim : Line2D
var aimPoint : Vector2

@export var DASH_SPEED := 750

@export var inputVector := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	WALK_ACCELERATION = 500
	MAX_WALK_SPEED = 100
	
	lineMouseAim = $"rb/debug/aimline"
	lineMouseAim.add_point(Vector2.ZERO)
	lineMouseAim.add_point(Vector2.ZERO)
	
	anim.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input_vector()
	
	if Input.is_action_pressed("jump"):
		pass
	if Input.is_action_just_pressed("dash"):
		velocity = inputVector * DASH_SPEED
		pass
	if Input.is_action_just_released("shoot_left"):
		pass
	if Input.is_action_just_pressed("shoot_right"):
		pass
	
	lineMouseAim.points[1] = get_global_mouse_position() - rb.global_position
	aimPoint = lineMouseAim.points[1]
	
	pass
	
func _physics_process(delta):
	super._physics_process(delta)
	if not velocity.length() > MAX_WALK_SPEED:
		velocity += inputVector * WALK_ACCELERATION * delta
	
	pass
	
func get_input_vector():
	inputVector = Vector2.ZERO
	if Input.is_action_pressed("left"):
		inputVector.x += 1
	if Input.is_action_pressed("right"):
		inputVector.x -= 1
	if Input.is_action_pressed("up"):
		inputVector.y += 1
	if Input.is_action_pressed("down"):
		inputVector.y -= 1
