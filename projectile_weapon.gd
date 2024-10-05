extends Weapon
class_name ProjecteWeapon

@export var shootPoint: Node2D

@export var projectile: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SWING_START_ANGLE = FRONT_FACING_ANGLE - (SWING_ARC_ANGLE/2)
	SWING_END_ANGLE = FRONT_FACING_ANGLE + (SWING_ARC_ANGLE/2)
	rotation_degrees = FRONT_FACING_ANGLE
	INHAND_ANGLE = SWING_START_ANGLE
	
	area = $"collider"
	area.connect("body_entered", hit_entity)
	hitbox = area.get_node("shape")
	hitbox.disabled = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if inUse:
		if curSwingTime < BASE_DURATION:
			curSwingTime += delta
			rotation_degrees = SWING_START_ANGLE + ((curSwingTime/BASE_DURATION) * (SWING_END_ANGLE - SWING_START_ANGLE))
		else:
			stop_use_weapon()
	pass

func use_weapon():
	super.use_weapon()
	swing()
	pass
	
func stop_use_weapon():
	super.stop_use_weapon()
	rotation_degrees = INHAND_ANGLE
	hitbox.disabled = true
	pass

func swing():
	hitbox.disabled = false
	rotation_degrees = SWING_START_ANGLE
	curSwingTime = 0
	pass

func hit_entity(body: Node2D):
	var parent = body.get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Entity:
			var entity = parent as Entity
			entity.hurt(BASE_DAMAGE, BASE_KNOCKBACK, Vector2.RIGHT.rotated(global_rotation))
	pass
