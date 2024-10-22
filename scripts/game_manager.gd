extends Node
class_name GM

enum GameState {TITLE_SCREEN=0, PLAYING=1, PAUSED=2}

var lvlScenes: Array[String]
var currentLvl: Level
var currentLvlIndex

#@onready var gameUI: UI = load()

var state: GameState

# Called when the node enters the scene tree for the first time.
func _ready():
	lvlScenes.append("res://scenes/levels/lvl_weddinghall.tscn")
	currentLvlIndex = 0
	state = GameState.TITLE_SCREEN
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GameState.TITLE_SCREEN:
			if Input.is_action_just_released("ui_accept"):
				start_game_transition()
				pass
			pass
		GameState.PLAYING:
			pass
		GameState.PAUSED:
			pass
	pass
	
func start_game_transition():
	pass
	
func start_game():
	load_level(currentLvlIndex)
	pass
	
func load_next_level():
	if load_level(currentLvlIndex+1):
		
		pass
	else:
		
		pass
	pass
	
#game is over
func end_game():
	pass

func load_level(index: int):
	if index > lvlScenes.size():
		return false
	var levelScene: PackedScene = load(lvlScenes[index])
	if currentLvl != null:
		currentLvl.queue_free()
	currentLvl = levelScene.instantiate()
	currentLvlIndex = index
	return true
	pass
