extends AnimatedSprite2D

var target: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	target = target.get_node("rb")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(target.global_position.x > global_position.x):
		scale.x = -1
	else:
		scale.x = 1
	pass
