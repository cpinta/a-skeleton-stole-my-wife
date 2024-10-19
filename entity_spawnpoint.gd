extends Node2D
class_name Entity_Spawnpoint

var spawnPool: Array[Entity]
var spawnChances: Array[float]

var SPAWN_TIMER_MIN: float = 3
var SPAWN_TIMER_MAX: float = 6
var SPAWN_TIME_SCALES: bool = true
var spawnTimer: float = 0

var level: Level


# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
