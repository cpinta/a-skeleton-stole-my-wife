class_name StatusEffect

@export var statusName := "Status Effect"
@export var description := "this effects you in someway"
@export var TIME_APPLIED :float = 1
@export var timeLeft :float = 1

func _init(time=TIME_APPLIED):
	TIME_APPLIED = time
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply(delta, entity: Entity):
	return 0
