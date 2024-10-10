extends Projectile
class_name PistolBullet


@export var SLOW_TIME: float = 0.5
@export var SLOW_MULTIPLIER: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _physics_process(delta):
	super._physics_process(delta)
	pass

func apply_attack(entity: Entity):
	super.apply_attack(entity)
	
	entity.hurt(BASE_DAMAGE, 0, Vector2.ZERO)
	entity.add_status_effect(SE_MovementSlow.new(entity, SLOW_TIME, SLOW_MULTIPLIER))
	self.queue_free()
	pass
