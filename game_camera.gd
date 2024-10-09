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
		var sceptre: Node2D = target.get_node_or_null("rb/body/hand/inner/Sceptre")
		if sceptre != null:
			debug1.text = "body scale:"+str(rad_to_deg(sceptre.global_rotation - deg_to_rad(90 * sceptre.global_scale.y)))+"\n"
	pass
