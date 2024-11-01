extends Node2D
class_name Level

enum LevelState { NOT_STARTED = 0, IN_PROGRESS = 1, FINISHED = 2}

var state: LevelState = LevelState.NOT_STARTED
var timeSinceLevelStart: float = 0


var music: AudioStreamPlayer2D

var INCREASE_SPAWN_CHANCE_EVERY_SECS: int = 30
var INCREASE_SPAWN_CHANCE_BY: float = 0.2
var spawnChanceMultiplier: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	music = $music
	music.play()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		LevelState.NOT_STARTED:
			pass
		LevelState.IN_PROGRESS:
			pass
		LevelState.FINISHED:
			pass
	if not music.playing:
		music.play()
	pass
	
func _physics_process(delta):
	match state:
		LevelState.NOT_STARTED:
			pass
		LevelState.IN_PROGRESS:
			timeSinceLevelStart += delta
			pass
		LevelState.FINISHED:
			pass

func change_state(newState: LevelState):
	state = newState
	match state:
		LevelState.NOT_STARTED:
			pass
		LevelState.IN_PROGRESS:
			timeSinceLevelStart = 0
			pass
		LevelState.FINISHED:
			pass
	pass
	
func unload():
	pass
