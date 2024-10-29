extends Node
class_name GM

enum GameState {TITLE_SCREEN=0, INTRO_CUTSCENE=4, GENDER_SELECT=5, PLAYING=1, PAUSED=2, DEAD=3}
enum GameScreen {TITLE, INTRO_CUTSCENE, GENDER_SELECT, DEATH}

var chosenGender: Player.Gender

var lvlScenes: Array[String]
var currentLvl: Level
var currentLvlIndex

var gameUIScene: PackedScene
var gameUI: UI

var titleScreenScene: PackedScene
var titleScreen: TitleScreen

var deathScreenScene: PackedScene
var deathScreen: DeathScreen

var introCutsceneScene: PackedScene
var introCutscene: Intro_Cutscene

var genderSelectScreenScene: PackedScene
var genderSelectScreen: GenderSelectScreen

var state: GameState

@onready var dict_entites = {\
	"Zombie": load("res://scenes/enemies/zombie.tscn"), \
	"Slime": load("res://scenes/enemies/slime.tscn"),\
	"Pumpkin": load("res://scenes/enemies/pumpkin.tscn"),\
	"Ghost": load("res://scenes/enemies/ghost.tscn"),\
	"Gargoyle": load("res://scenes/enemies/gargoyle.tscn"),\
}

var player: Player
var playerScene: PackedScene
var camera: GameCamera

var SCREEN_RESOLUTION: Vector2 = Vector2(320, 180)

# Called when the node enters the scene tree for the first time.
func _ready():
	lvlScenes.append("res://scenes/levels/lvl_weddinghall.tscn")
	currentLvlIndex = 0
	state = GameState.TITLE_SCREEN
	
	camera = get_tree().get_nodes_in_group("camera")[0]
	
	gameUIScene = load("res://scenes/ui/ui.tscn")
	titleScreenScene = load("res://scenes/ui/title_screen.tscn")
	deathScreenScene = load("res://scenes/ui/death_screen.tscn")
	playerScene = load("res://scenes/player.tscn")
	introCutsceneScene = load("res://scenes/intro_cutscene.tscn")
	genderSelectScreenScene = load("res://scenes/ui/gender_select_screen.tscn")
	
	load_screen(GameScreen.TITLE)
	
	pass # Replace with function body.

func start_gender_select():
	load_screen(GameScreen.GENDER_SELECT)
	genderSelectScreen.selectionDone.connect(gender_select_ended)
	
	
func gender_select_ended():
	start_intro()
	
	
func start_intro():
	change_state(GameState.INTRO_CUTSCENE)
	load_screen(GameScreen.INTRO_CUTSCENE)
	introCutscene.introDone.connect(finish_intro)
	pass

func finish_intro():
	unload_screen(GameScreen.INTRO_CUTSCENE)
	start_game()
	pass
	
func set_gender(gender: Player.Gender):
	chosenGender = gender
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		if get_tree().get_node_count_in_group("player") > 0:
			player = get_tree().get_nodes_in_group("player")[0]
			player.justDied.connect(load_death_screen)
		pass
	match state:
		GameState.TITLE_SCREEN:
			if Input.is_action_just_released("ui_accept"):
				unload_screen(GameScreen.TITLE)
				start_gender_select()
				pass
			pass
		GameState.INTRO_CUTSCENE:
			if Input.is_action_just_released("ui_accept"):
				finish_intro()
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
			camera.includeMouseMovement = true
			pass
		GameState.PLAYING:
			camera.includeMouseMovement = true
			pass
		GameState.PAUSED:
			pass
		GameState.DEAD:
			camera.includeMouseMovement = false
			pass
	pass
	
func start_game_transition():
	pass
	
func start_game():
	unload_screen(GameScreen.TITLE)
	change_state(GameState.PLAYING)
	load_level(currentLvlIndex)
	load_game_ui()
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
	
	if player == null:
		load_player()
	player.global_position = get_tree().get_nodes_in_group("playerspawn")[0].global_position
	
	return true
	pass
	
func load_player():
	player = playerScene.instantiate() as Player
	player.gender = chosenGender
	self.add_child(player)
	player.justDied.connect(load_death_screen)
	pass	
	
func load_game_ui():
	if gameUI == null:
		gameUI = gameUIScene.instantiate() as UI
		self.add_child(gameUI)
	pass
	
func unload_game_ui():
	if gameUI != null:
		gameUI.queue_free()
	pass
	
func load_death_screen():
	if gameUI != null:
		unload_game_ui()
	
	player.reparent(get_tree().root)
	player.global_position = Vector2.ZERO
	camera.includeMouseMovement = false
	currentLvl.queue_free()
	load_screen(GameScreen.DEATH)
	deathScreen.reparent(camera)
	deathScreen.position = -SCREEN_RESOLUTION/2
	camera.targetOffset = Vector2(0, -20)
	
	deathScreen.tryagain.connect(try_again)
	deathScreen.quitgame.connect(quit)
	
	pass
	
func try_again():
	unload_screen(GameScreen.DEATH)
	load_level(currentLvlIndex)
	load_game_ui()
	camera.includeMouseMovement = true
	player.allowInput = true
	pass
	
func quit():
	get_tree().quit()
	pass

func load_screen(screenType: GameScreen):
	var screen
	var screenScene
	match screenType:
		GameScreen.TITLE:
			screen = titleScreen
			screenScene = titleScreenScene
		GameScreen.DEATH:
			screen = deathScreen
			screenScene = deathScreenScene
		GameScreen.INTRO_CUTSCENE:
			screen = introCutscene
			screenScene = introCutsceneScene
		GameScreen.GENDER_SELECT:
			screen = genderSelectScreen
			screenScene = genderSelectScreenScene
			
	if screen != null:
		print("WARNING: Tried loading "+str(screenType)+" but its already loaded")
		return
	screen = screenScene.instantiate()
	self.add_child(screen)
	
	match screenType:
		GameScreen.TITLE:
			titleScreen = screen
		GameScreen.DEATH:
			deathScreen = screen
		GameScreen.INTRO_CUTSCENE:
			introCutscene = screen
		GameScreen.GENDER_SELECT:
			genderSelectScreen = screen
	pass
	
func unload_screen(screenType: GameScreen):
	var screen
	var screenScene
	match screenType:
		GameScreen.TITLE:
			screen = titleScreen
		GameScreen.DEATH:
			screen = deathScreen
		GameScreen.INTRO_CUTSCENE:
			screen = introCutscene
		GameScreen.GENDER_SELECT:
			screen = genderSelectScreen
			
	if screen == null:
		print("WARNING: Tried UNloading "+str(screenType)+" but its already not loaded")
		return
	screen.queue_free()
	pass
