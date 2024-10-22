extends StatusEffect
class_name SE_Hitstun

var TIME_SCALE: float = 0.001

#SE_Hitstun.new(self, time)
func _init(entity: Entity, time=TIME_APPLIED):
	super._init(entity, time)
	statusName = "Hitstun"
	description = "ya got hit... now stunned"
	pass

func apply(delta):
	print(str(Time.get_ticks_msec())," applying hitstun ",TIME_APPLIED)
	Engine.time_scale = TIME_SCALE
	if target != null:
		await target.get_tree().create_timer(TIME_APPLIED, true, false, true).timeout
	Engine.time_scale = 1
	return -1

func was_removed():
	super.was_removed()
	pass