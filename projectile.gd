extends Weapon
class_name Projectile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(global_rotation) * attackspeed
	pass
	
func setup(owner: Entity, speed: float):
	
	pass

func hit_entity(body: Node2D):
	var parent = body.get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Entity:
			var entity = parent as Entity
			entity.hurt(BASE_DAMAGE, BASE_KNOCKBACK, Vector2.RIGHT.rotated(global_rotation))
	pass
