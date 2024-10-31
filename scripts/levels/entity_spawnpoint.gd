extends Node2D
class_name Entity_Spawnpoint

@export var spawnPool: Array[String]
@export var spawnWeights: Array[int]
var spawnWeightTotal: int = 0

@export var SPAWN_TIME_MIN: float = 3
@export var SPAWN_TIME_MAX: float = 6
@export var SPAWNS_SCALE_W_TIME: bool = true
@export var HAS_SPAWN_COUNT_LIMIT: bool = false
@export var SPAWN_COUNT_LIMIT: int = 0
var spawnTime: float = 0
var spawnTimer: float = 0
var spawnCountsLeft: int = 0

var active: bool = true
@export var HAS_ACTIVATOR: bool = false
var activator: Area2D

var level: Level

# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	for weight in spawnWeights:
		spawnWeightTotal += weight
		
	spawnTime = randf_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX)
	$debuglbl.visible = false
	
	if HAS_SPAWN_COUNT_LIMIT:
		spawnCountsLeft = SPAWN_COUNT_LIMIT
		
	if HAS_ACTIVATOR:
		active = false
		activator = $Activator
		activator.area_entered.connect(activator_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if (HAS_SPAWN_COUNT_LIMIT and spawnCountsLeft > 0) or not HAS_SPAWN_COUNT_LIMIT:
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
	if HAS_SPAWN_COUNT_LIMIT:
		spawnCountsLeft -= 1
	pass
	
func activator_entered(body: Node2D):
	if active:
		return
	var parent = body.get_parent().get_parent()
	print("hit:",parent.name)
	if parent != null:
		if parent is Player:
			active = true
	pass
