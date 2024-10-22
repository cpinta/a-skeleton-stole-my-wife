extends Camera2D

@export var target: Entity
@export var tOffset: Vector2

@export var debug1: RichTextLabel

@export var includeMouseMovement: bool = true
@export var MAX_MOUSE_DISTANCE: float = 20
@export var MOUSE_DISTANCE_MULTIPLIER: float = 0.2
@export var MOUSE_LERP: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	#debug1 = $Control/text
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var mouseVector: Vector2 = get_global_mouse_position() - target.global_position;
		global_position = global_position.lerp(target.global_position + tOffset + (mouseVector.normalized() * mouseVector.length() * MOUSE_DISTANCE_MULTIPLIER), MOUSE_LERP)
	pass
