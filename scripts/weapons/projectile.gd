extends Weapon
class_name Projectile

@export var area: Area2D
@export var hitbox: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area = $"collider"
	area.connect("area_entered", hit_entity)
	hitbox = area.get_node("shape")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(global_rotation) * attackspeed
	pass
	
func setup(owner: Entity, speed: float, damage: float):
	self.BASE_ATTACKSPEED = speed
	self.BASE_DAMAGE = damage
	pass
	
func apply_attack(entity: Entity):
	super.apply_attack(entity)
	pass
