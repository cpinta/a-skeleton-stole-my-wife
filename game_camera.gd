extends Camera2D

@export var target: Entity
@export var tOffset: Vector2

@export var debug1: RichTextLabel

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
			position = rb.position + tOffset
	pass
