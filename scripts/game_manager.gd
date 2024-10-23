extends Node
class_name GM

enum GameState {TITLE_SCREEN=0, PLAYING=1, PAUSED=2}

var lvlScenes: Array[String]
var currentLvl: Level
var currentLvlIndex

@export var gameUIScene: PackedScene
var gameUI: UI

@export var titleScreenScene: PackedScene
var titleScreen: TitleScreen

var state: GameState

@onready var dict_entites = {\
	"Zombie": load("res://scenes/enemies/zombie.tscn"), \
	"Slime": load("res://scenes/enemies/slime.tscn"),\
	"Pumpkin": load("res://scenes/enemies/pumpkin.tscn"),\
	"Ghost": load("res://scenes/enemies/ghost.tscn"),\
	"Gargoyle": load("res://scenes/enemies/gargoyle.tscn"),\
}

# Called when the node enters the scene tree for the first time.
func _ready():
	lvlScenes.append("res://scenes/levels/lvl_weddinghall.tscn")
	currentLvlIndex = 0
	state = GameState.TITLE_SCREEN
	
	gameUIScene = load("res://scenes/ui/ui.tscn")
	titleScreenScene = load("res://scenes/ui/title_screen.tscn")
	load_title_screen()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		GameState.TITLE_SCREEN:
			if Input.is_action_just_released("ui_accept"):
				start_game()
				change_state(GameState.PLAYING)
				pass
			pass
		GameState.PLAYING:
			pass
		GameState.PAUSED:
			pass
	pass
	
func change_state(state: GameState):
	self.state = state
	match state:
		GameState.TITLE_SCREEN:
			pass
		GameState.PLAYING:
			pass
		GameState.PAUSED:
			pass
	pass
	
func start_game_transition():
	pass
	
func start_game():
	unload_title_screen()
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
	if gameUI != null:
		gameUI.queue_free()
	pass

func load_level(index: int):
	if index > lvlScenes.size():
		return false
	var levelScene: PackedScene = load(lvlScenes[index])
	if currentLvl != null:
		currentLvl.queue_free()
	currentLvl = levelScene.instantiate() as Level
	print(levelScene.resource_name)
	self.add_child(currentLvl)
	currentLvlIndex = index
	if gameUI == null:
		gameUI = gameUIScene.instantiate() as UI
		self.add_child(gameUI)
	return true
	pass
	
func load_title_screen():
	if titleScreen != null:
		print("WARNING: Tried loading title screen but its already loaded")
		return
	titleScreen = titleScreenScene.instantiate()
	self.add_child(titleScreen)
	pass
	
func unload_title_screen():
	if titleScreen == null:
		print("WARNING: Tried UNloading title screen but its already not loaded")
		return
	titleScreen.queue_free()
	pass
