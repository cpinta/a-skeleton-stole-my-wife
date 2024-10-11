extends Camera2D

@export var target: Entity
@export var tOffset: Vector2

@export var debug1: RichTextLabel

@export var includeMouseMovement: bool = true
@export var MAX_MOUSE_DISTANCE: float = 20
@export var MOUSE_LERP: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	debug1 = $Control/text
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		var rb = target.get_node_or_null("rb")
		if rb != null:
			global_position = global_position.lerp(rb.global_position + tOffset + ((get_global_mouse_position() - rb.global_position).normalized() * MAX_MOUSE_DISTANCE), MOUSE_LERP)
		debug1.text = "mouse vector:"+str(((get_global_mouse_position() - rb.global_position) * MAX_MOUSE_DISTANCE))+"\n"
	pass
