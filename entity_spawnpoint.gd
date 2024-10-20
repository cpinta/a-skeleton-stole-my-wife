extends Node2D
class_name Entity_Spawnpoint

@export var spawnPool: Array[Entity]
@export var spawnWeights: Array[int]
var spawnWeightTotal: int = 0

var SPAWN_TIMER_MIN: float = 3
var SPAWN_TIMER_MAX: float = 6
var SPAWNS_SCALE_W_TIME: bool = true
var spawnTimer: float = 0

var level: Level

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	for weight in spawnWeights:
		spawnWeightTotal += weight
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_spawn_from_weights():
	var chosen = randi_range(0, spawnWeightTotal)
	var count = spawnWeights[0]
	var i = 0
	while count < chosen:
		count += spawnWeights[i]
		i += 1
	pass
