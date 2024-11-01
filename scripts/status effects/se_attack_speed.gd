extends StatusEffect
class_name SE_Attack_Speed

var ADDITION: float = 1

#SE_Hitstun.new(self, time)
func _init(entity: Entity, time=TIME_APPLIED, addition=ADDITION):
	super._init(entity, time)
	statusName = "Attack Speed Up"
	description = "fast hits"
	
	ADDITION = addition
	pass

func apply(delta):
	target.attack_speed += ADDITION
	return 1

func was_removed():
	super.was_removed()
	pass
