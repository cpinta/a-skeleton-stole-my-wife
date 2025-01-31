extends ProjecteWeapon
class_name Pistol


# Called when the node enters the scene tree for the first time.
func _ready():
	BASE_AMMO_COUNT = 10
	START_DROPPED = false
	super._ready()
	projectile = load("res://scenes/weapons/wp_pistolbullet.tscn")
	anim = get_node("animation")
	anim.play("idle")
	
	usesAmmo = true
	
	elementHeight.SHADOW_USES_PARENT_ORIGIN = true
	drop(5)
	
	IS_CONTINUOUS = false
	EQUIP_ANGLE = 90
	BASE_DAMAGE = 4
	BASE_TIME_BT_BULLETS = 0.25
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if onCooldown:
		anim.play("reload")
	elif anim.animation == "reload" && not onCooldown:
		anim.play("idle")
	pass

func shoot():
	super.shoot()
	anim.play("shoot")
