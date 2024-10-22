extends Sprite2D
class_name Shadow

var element: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if element != null:
		global_position = element.global_position
	else:
		queue_free()
	pass

func setup(element: Node2D):
	self.element = element
