extends StatusEffect
class_name SE_Invincibility


#SE_Invincibility.new(self, POST_HIT_INVINCIBILITY_TIME)
func _init(entity: Entity, time=TIME_APPLIED):
	super._init(entity, time)
	statusName = "Invincibility"
	description = "you are untouchable. mostly"
	pass

func apply(delta):
	target.isHittable = false
	timeLeft -= delta
	return timeLeft

func was_removed():
	super.was_removed()
	target.isHittable = true
	target.anim.visible = true
	pass
