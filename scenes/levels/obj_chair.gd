extends Node2D
class_name Obj_Chair

enum TopDownDirection {UP, RIGHT, DOWN, LEFT}

@export var anim: AnimatedSprite2D
@export var facingDirection: TopDownDirection

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $animation
	anim.play(TopDownDirection.keys()[facingDirection])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
