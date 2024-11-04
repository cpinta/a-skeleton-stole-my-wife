extends StatusEffect
class_name SE_Health

var ADDITION: float = 1

#SE_Hitstun.new(self, time)
func _init(entity: Entity, time=TIME_APPLIED, addition=ADDITION):
	super._init(entity, time)
	statusName = "Health Up"
	description = "Erm uh health up"
	
	ADDITION = addition
	pass

func apply(delta):
	target.total_health += ADDITION
	return 1

func was_removed():
	super.was_removed()
	pass
