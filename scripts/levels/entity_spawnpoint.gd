extends Node2D
class_name Entity_Spawnpoint

@export var BASE_PATH: String = "res://scenes/"
@export var spawnPool: Array[String]
@export var spawnWeights: Array[int]
var spawnWeightTotal: int = 0

@export var SPAWN_TIME_MIN: float = 3
@export var SPAWN_TIME_MAX: float = 6
var SPAWNS_SCALE_W_TIME: bool = true
@export var spawnTime: float = 0
@export var spawnTimer: float = 0

var level: Level

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	for weight in spawnWeights:
		spawnWeightTotal += weight
		
	spawnTime = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
	$debuglbl.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawnTimer < spawnTime:
		spawnTimer += delta
	else:
		get_random_spawn_from_weights()
		spawnTime = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
		spawnTimer = 0
	pass

func get_random_spawn_from_weights():
	var chosen = randi_range(0, spawnWeightTotal)
	var count = spawnWeights[0]
	var i = 0
	while count < chosen:
		count += spawnWeights[i]
		i += 1
	spawn_entity(i)
	pass

func spawn_entity(index: int):
	var entity = Game.dict_entites[spawnPool[index]].instantiate()
	self.owner.add_child(entity)
	entity.global_position = self.global_position
	pass
