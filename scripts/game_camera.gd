extends Camera2D
class_name GameCamera

@export var target: Entity
@export var targetOffset: Vector2

@export var debug1: RichTextLabel

@export var includeMouseMovement: bool = true
@export var MAX_MOUSE_DISTANCE: float = 20
@export var MOUSE_DISTANCE_MULTIPLIER: float = 0.2
@export var MOUSE_LERP: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_node_count_in_group("player") > 0:
		target = get_tree().get_nodes_in_group("player")[0]
	#debug1 = $Control/text
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var mouseVector: Vector2 = Vector2.ZERO
		if includeMouseMovement:
			mouseVector = get_global_mouse_position() - target.global_position
		global_position = global_position.lerp(target.global_position + targetOffset + (mouseVector.normalized() * mouseVector.length() * MOUSE_DISTANCE_MULTIPLIER), MOUSE_LERP)
	else:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
	pass
