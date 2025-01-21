extends Camera2D
class_name GameCamera

@export var target: Player
@export var targetOffset: Vector2

@export var debug1: RichTextLabel

@export var includeMouseMovement: bool = true
@export var MAX_MOUSE_DISTANCE: float = 50
@export var MOUSE_DISTANCE_MULTIPLIER: float = 0.2
@export var MOUSE_LERP: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_node_count_in_group("player") > 0:
		target = get_tree().get_nodes_in_group("player")[0]
	#debug1 = $Control/text
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if target != null:
		var mouseVector: Vector2 = Vector2.ZERO
		if includeMouseMovement:
			mouseVector = target.inputHandler.get_aim_vector()
		global_position = global_position.lerp(target.global_position + targetOffset + (mouseVector * MAX_MOUSE_DISTANCE * MOUSE_DISTANCE_MULTIPLIER), MOUSE_LERP)
	else:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
	pass
