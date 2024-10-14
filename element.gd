extends Node2D
class_name Element

var shadowPrefab: PackedScene
var shadow: Shadow
var height: float = 0
var heightFallSpeed: float = 0
var DOES_HEIGHT_USE_GRAVITY: bool = true
var HEIGHT_FALL_ACCELERATION: float = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	shadowPrefab = load("res://shadow.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	
	pass

func load_shadow():
	shadow = shadowPrefab.instantiate()
	shadow.setup(self)
	get_tree().root.add_child.call_deferred(shadow)
	pass
	
func unload_shadow():
	if shadow != null:
		shadow.queue_free()
		shadow = null
	pass
