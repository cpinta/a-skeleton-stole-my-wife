extends AnimatedSprite2D
class_name HeightElement

@export var anim: AnimatedSprite2D
@export var animGroundHeight: float = 0

var shadowPrefab: PackedScene
var shadow: Shadow

# the altitude of the entity
var height: float = 0
var heightOnGround: bool = true
var wasJustOffGround: bool = false
var INAIR_HEIGHT: float = 25
var isInAir: bool = false

# the height of the entity itself
var entity_height: float = 25

var heightVerticalSpeed: float = 0
var DOES_HEIGHT_USE_GRAVITY: bool = true
var GRAVITY: float = 50
var isAffectedByHeight: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	shadowPrefab = load("res://shadow.tscn")
	anim = get_node_or_null("animation")
	if anim == null:
		anim = get_node_or_null("body/animation")
		if anim == null:
			anim = self
			if anim == null:
				print("ERROR: "+name+" couldn't find animator")
	
	if anim != null:
		animGroundHeight = anim.position.y
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	wasJustOffGround = false
	if isAffectedByHeight:
		if not height < 0:
			if DOES_HEIGHT_USE_GRAVITY:
				heightVerticalSpeed -= delta * GRAVITY
				height += delta * heightVerticalSpeed
			if height > INAIR_HEIGHT:
				isInAir = true
			else:
				isInAir = false
			
			if height < 0:
				if not heightOnGround:
					wasJustOffGround = true
				heightOnGround = true
				height = 0
			else:
				heightOnGround = false
		else:
			if not heightOnGround:
				wasJustOffGround = true
			heightOnGround = true
			height = 0
		anim.position = Vector2(anim.position.x, animGroundHeight - height)
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
