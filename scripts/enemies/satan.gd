extends UI_Element
class_name Satan

@export var anim = AnimatedSprite2D

@export var RISE_TIME: float = 6
@export var riseTimer: float = 0
@export var raising: bool = true

@export var STARE_TIME: float = 4
@export var stareTimer: float = 0
@export var staring: bool = false

@export var POINT_TIME: float = 2
@export var pointTimer: float = 0
@export var pointing: bool = false

@export var LEAVE_TIME: float = 0.5
@export var leaveTimer: float = 0
@export var leaving: bool = false

@export var START_POS: Vector2 = Vector2(256, 202)
@export var POINT_POS: Vector2 = Vector2(256, 148)
@export var LEAVE_POS: Vector2 = Vector2(343, 148)

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $animation
	anim.play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if raising:
		if riseTimer < RISE_TIME:
			global_position = START_POS + ((riseTimer/RISE_TIME) * (POINT_POS-START_POS))
			riseTimer += delta
		else:
			raising = false
			staring = true
			pointing = false
			leaving = false
			pass
	else:
		if staring:
			if stareTimer < STARE_TIME:
				stareTimer += delta
			else:
				raising = false
				staring = false
				pointing = true
				leaving = false
				anim.play("pointing")
		else:
			if pointing:
				if pointTimer < POINT_TIME:
					pointTimer += delta
				else:
					raising = false
					staring = false
					pointing = false
					leaving = true
			else:
				if leaving:
					if leaveTimer < LEAVE_TIME:
						global_position = POINT_POS + ((leaveTimer/LEAVE_TIME) * (LEAVE_POS-POINT_POS))
						leaveTimer += delta
					else:
						queue_free()
					
	pass

func spawn_enemies():
	
	pass
