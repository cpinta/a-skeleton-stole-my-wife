extends ProjecteWeapon
class_name Pistol


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	projectile = load("res://sprites/weapons/pistolbullet.tscn")
	
	IS_CONTINUOUS = false
	EQUIP_ANGLE = 90
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
