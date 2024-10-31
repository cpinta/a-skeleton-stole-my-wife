extends Node
class_name GM

enum GameState {TITLE_SCREEN=0, INTRO_CUTSCENE=4, GENDER_SELECT=5, PLAYING=1, PAUSED=2, DEAD=3}
enum GameScreen {TITLE, INTRO_CUTSCENE, GENDER_SELECT, PASTOR, DEATH}

var chosenGender: Player.Gender

var lvlScenes: Array[String]
var currentLvl: Level
var currentLvlIndex


var screenScenes = { \
GameScreen.TITLE:PackedScene, \
GameScreen.DEATH:PackedScene, \
GameScreen.INTRO_CUTSCENE:PackedScene, \
GameScreen.GENDER_SELECT:PackedScene, \
GameScreen.PASTOR:PackedScene}

var screens = { \
GameScreen.TITLE:null, \
GameScreen.DEATH:null, \
GameScreen.INTRO_CUTSCENE:null, \
GameScreen.GENDER_SELECT:null, \
GameScreen.PASTOR:null}

var gameUIScene: PackedScene
var gameUI: UI

var timesPastorVisited: int = 0

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

var satanScene: PackedScene
var satan: Satan
var SATAN_SPAWN_SCORE: int = 700
var satanWasSpawned: bool = false

var SATAN_SPAWN_COUNT: int = 20
var SATAN_SPAWN_RADIUS: float = 90

var WIN_SCORE: int = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	lvlScenes.append("res://scenes/levels/lvl_weddinghall.tscn")
	currentLvlIndex = 0
	state = GameState.TITLE_SCREEN
	
	camera = get_tree().get_nodes_in_group("camera")[0]
	
	playerScene = load("res://scenes/player.tscn")
	gameUIScene = load("res://scenes/ui/ui.tscn")
	
	screenScenes[GameScreen.TITLE] = load("res://scenes/ui/title_screen.tscn")
	screenScenes[GameScreen.DEATH] = load("res://scenes/ui/death_screen.tscn")
	screenScenes[GameScreen.INTRO_CUTSCENE] = load("res://scenes/intro_cutscene.tscn")
	screenScenes[GameScreen.GENDER_SELECT] = load("res://scenes/ui/gender_select_screen.tscn")
	screenScenes[GameScreen.PASTOR] = load("res://scenes/ui/pastorscreen.tscn")
	
	satanScene = load("res://scenes/enemies/satan.tscn")
	
	#start_game()
	start_game_skip_pastor()
	spawn_satan()
	
	#start_gender_select() #WHAT SHOULD REALLY BE HERE
	
	pass

func start_gender_select():
	load_screen(GameScreen.GENDER_SELECT)
	screens[GameScreen.GENDER_SELECT].selectionDone.connect(gender_select_ended)
	
	
func gender_select_ended():
	start_intro()
	
	
func start_intro():
	change_state(GameState.INTRO_CUTSCENE)
	load_screen(GameScreen.INTRO_CUTSCENE) #SCREEN
	screens[GameScreen.INTRO_CUTSCENE].introDone.connect(finish_intro)
	pass

func finish_intro():
	unload_screen(GameScreen.INTRO_CUTSCENE) #SCREEN
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
				unload_screen(GameScreen.TITLE) #SCREEN
				start_gender_select()
				pass
			pass
		GameState.INTRO_CUTSCENE:
			if Input.is_action_just_released("ui_accept"):
				finish_intro()
				pass
			pass
		GameState.PLAYING:
			if player.score > SATAN_SPAWN_SCORE:
				spawn_satan()
			if player.score > WIN_SCORE:
				self.queue_free()
				pass
			pass
		GameState.PAUSED:
			pass
	pass
	
func spawn_satan():
	satanWasSpawned = true
	satan = satanScene.instantiate()
	camera.add_child(satan)
	
	satan.sendEnemies.connect(spawn_satans_enemies)
	pass
	
func spawn_satans_enemies():
	var centerPoint: Vector2 = player.global_position
	var circumfrence: float = 2*PI
	var moveEveryEnemy: float = circumfrence/SATAN_SPAWN_COUNT
	var currentRotation: float = 0
	
	var keys: Array = dict_entites.keys()
	
	for i in range(0, SATAN_SPAWN_COUNT):
		currentRotation += moveEveryEnemy
		var spawnLoc: Vector2 = centerPoint + (Vector2.RIGHT.rotated(currentRotation) * SATAN_SPAWN_RADIUS)
		var enemy = dict_entites[keys[randi_range(0, keys.size()-2)]].instantiate()
		currentLvl.add_child(enemy)
		enemy.add_status_effect(SE_MovementSlow.new(enemy, 4, 0))
		enemy.global_position = spawnLoc
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
	unload_all_screens() #SCREEN
	change_state(GameState.PLAYING)
	load_level(currentLvlIndex)
	load_game_ui()
	show_pastor(PastorScreen.PastorState.INTRO, true)
	pass
	
func start_game_skip_pastor():
	unload_all_screens() #SCREEN
	change_state(GameState.PLAYING)
	load_level(currentLvlIndex)
	load_game_ui()
	player.allowInput = true
	pass
	
func freeze_enemies():
	if get_tree().get_node_count_in_group("enemies") > 0:
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.canMove = false
	pass

func unfreeze_enemies():
	if get_tree().get_node_count_in_group("enemies") > 0:
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.canMove = false
	pass
	
func show_pastor(pstate: PastorScreen.PastorState = PastorScreen.PastorState.SHOWING_ITEMS, hasTutorial: bool = false):
	load_screen(GameScreen.PASTOR) #SCREEN
	screens[GameScreen.PASTOR].setup(pstate, hasTutorial)
	screens[GameScreen.PASTOR].reparent(camera, false)
	screens[GameScreen.PASTOR].position = -SCREEN_RESOLUTION/2
	player.allowInput = false
	timesPastorVisited += 1
	screens[GameScreen.PASTOR].gone.connect(pastor_done)
	freeze_enemies()
	pass
	
func pastor_done():
	player.allowInput = true
	unfreeze_enemies()
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

func load_level(index: int, canPlayerMove: bool = true):
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
		load_player(canPlayerMove)
	player.global_position = get_tree().get_nodes_in_group("playerspawn")[0].global_position
	
	return true
	pass
	
func load_player(canPlayerMove: bool):
	player = playerScene.instantiate() as Player
	player.gender = chosenGender
	player.canMove = canPlayerMove
	currentLvl.add_child(player)
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
	unload_all_screens()
	
	player.reparent(get_tree().root)
	player.global_position = Vector2.ZERO
	camera.includeMouseMovement = false
	currentLvl.queue_free()
	load_screen(GameScreen.DEATH) #SCREEN
	screens[GameScreen.DEATH].reparent(camera)
	screens[GameScreen.DEATH].position = -SCREEN_RESOLUTION/2
	camera.targetOffset = Vector2(0, -20)
	
	screens[GameScreen.DEATH].tryagain.connect(try_again)
	screens[GameScreen.DEATH].quitgame.connect(quit)
	
	pass
	
func unload_all_screens():
	unload_game_ui()
	for key in screens:
		if screens[key] != null:
			screens[key].queue_free()

func try_again():
	unload_all_screens() #SCREEN
	load_level(currentLvlIndex)
	load_game_ui()
	camera.includeMouseMovement = true
	player.allowInput = true
	pass
	
func quit():
	get_tree().quit()
	pass

func load_screen(screenType: GameScreen):
	if screens[screenType] != null:
		print("WARNING: Tried loading "+str(screenType)+" but its already loaded")
		return
	screens[screenType] = screenScenes[screenType].instantiate()
	self.add_child(screens[screenType])
	pass
	
func unload_screen(screenType: GameScreen):
	if screens[screenType] == null:
		print("WARNING: Tried UNloading "+str(screenType)+" but its already not loaded")
		return
	screens[screenType].queue_free()
	pass
