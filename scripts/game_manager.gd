extends Node
class_name GM

enum GameState {TITLE_SCREEN=0, INTRO_CUTSCENE=4, END_CUTSCENE=6, GENDER_SELECT=5, PLAYING=1, PAUSED=2, DEAD=3}
enum GameScreen {TITLE, INTRO_CUTSCENE, GENDER_SELECT, PASTOR, DEATH, END_CUTSCENE}

var inputHandlerScene: PackedScene
var selectedGameInput: InputHandler.GameInput = InputHandler.GameInput.TOUCH

var chosenGender: Player.Gender

var lvlScenes: Array[String]
var currentLvl: Level
var currentLvlIndex


var screenScenes = { \
GameScreen.TITLE:PackedScene, \
GameScreen.DEATH:PackedScene, \
GameScreen.INTRO_CUTSCENE:PackedScene, \
GameScreen.GENDER_SELECT:PackedScene, \
GameScreen.PASTOR:PackedScene, \
GameScreen.END_CUTSCENE:PackedScene}

var screens = { \
GameScreen.TITLE:null, \
GameScreen.DEATH:null, \
GameScreen.INTRO_CUTSCENE:null, \
GameScreen.GENDER_SELECT:null, \
GameScreen.PASTOR:null, \
GameScreen.END_CUTSCENE:null}

var gameUIScene: PackedScene
var gameUI: UI

var gameUItouchScene: PackedScene
var gameUItouch: UI

var timesPastorVisited: int = 0

var state: GameState

signal hideControls
signal showControls

@onready var dict_entites = {\
	"Zombie": load("res://scenes/enemies/zombie.tscn"), \
	"Slime": load("res://scenes/enemies/slime.tscn"),\
	"Pumpkin": load("res://scenes/enemies/pumpkin.tscn"),\
	"Ghost": load("res://scenes/enemies/ghost.tscn"),\
	"Gargoyle": load("res://scenes/enemies/gargoyle.tscn"),\
}

@onready var dict_weapons = {\
	"Corn Stalk": load("res://scenes/weapons/wp_corn_stalk.tscn"),\
	"Hammer": load("res://scenes/weapons/wp_hammer.tscn"),\
	"Pistol": load("res://scenes/weapons/wp_pistol.tscn"),\
	"Scythe": load("res://scenes/weapons/wp_scythe.tscn"),\
	"Sledgehammer": load("res://scenes/weapons/wp_sledgehammer.tscn"),\
	"Soda": load("res://scenes/weapons/wp_soda.tscn")
}

var player: Player
var playerScene: PackedScene
var camera: GameCamera

var SCREEN_RESOLUTION: Vector2 = Vector2(320, 180)

var satanScene: PackedScene
var satan: Satan
var SATAN_SPAWN_SCORE: int = 800
var satanWasSpawned: bool = false

var SATAN_SPAWN_COUNT: int = 20
var SATAN_SPAWN_RADIUS: float = 90

var WIN_SCORE: int = 1300

var credits: Label

var debug: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	lvlScenes.append("res://scenes/levels/lvl_weddinghall.tscn")
	currentLvlIndex = 0
	state = GameState.TITLE_SCREEN
	
	camera = get_tree().get_nodes_in_group("camera")[0]
	
	playerScene = load("res://scenes/player.tscn")
	inputHandlerScene = load("res://scenes/input_handler.tscn")
	gameUIScene = load("res://scenes/ui/ui.tscn")
	gameUItouchScene = load("res://scenes/ui/touch_ui.tscn")
	
	screenScenes[GameScreen.TITLE] = load("res://scenes/ui/title_screen.tscn")
	screenScenes[GameScreen.DEATH] = load("res://scenes/ui/death_screen.tscn")
	screenScenes[GameScreen.INTRO_CUTSCENE] = load("res://scenes/intro_cutscene.tscn")
	screenScenes[GameScreen.GENDER_SELECT] = load("res://scenes/ui/gender_select_screen.tscn")
	screenScenes[GameScreen.PASTOR] = load("res://scenes/ui/pastorscreen.tscn")
	screenScenes[GameScreen.END_CUTSCENE] = load("res://scenes/ending_cutscene.tscn")
	
	credits = $"credits label"
	credits.visible = false
	satanScene = load("res://scenes/enemies/satan.tscn")
	
	#set_gender(Player.Gender.HOMETTE)
	#start_game()
	#load_title_screen()
	start_game_skip_pastor()
	#player.current_health = 1
	#player.score = 999
	#spawn_satan()
	#camera.global_position = Vector2(1000, 2000)
	#start_ending()
	#load_title_screen() #WHAT SHOULD REALLY BE HERE
	#pass
	
var skipPastor: bool = false


func load_title_screen():
	load_screen(GameScreen.TITLE)
	var title = screens[GameScreen.TITLE] as TitleScreen
	title.startPressed.connect(title_start)
	
func title_start(input: InputHandler.GameInput):
	selectedGameInput = input
	unload_screen(GameScreen.TITLE) #SCREEN
	start_gender_select()
	pass

func start_gender_select():
	load_screen(GameScreen.GENDER_SELECT)
	screens[GameScreen.GENDER_SELECT].selectionDone.connect(gender_select_ended)
	
func get_random_weapon():
	var keys = dict_weapons.keys()
	return dict_weapons[keys[randi_range(0, keys.size()-1)]]
	pass
	
func gender_select_ended():
	start_intro()
	
	
func start_ending():
	change_state(GameState.END_CUTSCENE)
	unload_all_screens()
	if currentLvl != null:
		currentLvl.queue_free()
	load_screen(GameScreen.END_CUTSCENE) #SCREEN
	screens[GameScreen.END_CUTSCENE].reparent(camera, false)
	screens[GameScreen.END_CUTSCENE].endingDone.connect(finish_ending)
	#camera.position = Vector2.ZERO
	pass
	
func finish_ending():
	unload_all_screens()
	camera.global_position = Vector2.ZERO
	credits.visible = true
	pass
	
func start_intro():
	change_state(GameState.INTRO_CUTSCENE)
	load_screen(GameScreen.INTRO_CUTSCENE) #SCREEN
	screens[GameScreen.INTRO_CUTSCENE].introDone.connect(finish_intro)
	pass

func finish_intro():
	unload_all_screens()
	start_game()
	pass
	
func set_gender(gender: Player.Gender):
	chosenGender = gender
	pass
	
func load_current_game_ui():
	match selectedGameInput:
		InputHandler.GameInput.MOUSE:
			unload_touch_controls_and_ui()
			load_game_ui()
			pass
		InputHandler.GameInput.TOUCH:
			unload_game_ui()
			load_touch_controls_and_ui()
			pass
	pass

func unload_current_game_ui():
	match selectedGameInput:
		InputHandler.GameInput.MOUSE:
			unload_game_ui()
			pass
		InputHandler.GameInput.TOUCH:
			unload_touch_controls_and_ui()
			pass
	pass

func controls_chosen(newInput: InputHandler.GameInput):
	match newInput:
		InputHandler.GameInput.MOUSE:
			unload_touch_controls_and_ui()
			load_game_ui()
			pass
		InputHandler.GameInput.TOUCH:
			unload_game_ui()
			load_touch_controls_and_ui()
			pass
	pass

func load_touch_controls_and_ui():
	if gameUItouch == null:
		gameUItouch = gameUItouchScene.instantiate() as UI
		self.add_child(gameUItouch)
	pass

func unload_touch_controls_and_ui():
	if gameUItouch != null:
		gameUItouch.queue_free()
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
			pass
		GameState.INTRO_CUTSCENE:
			if Input.is_action_just_released("ui_accept"):
				finish_intro()
				pass
			pass
		GameState.PLAYING:
			if player.score > SATAN_SPAWN_SCORE:
				if not satanWasSpawned:
					spawn_satan()
			if player.score > WIN_SCORE:
				start_ending()
				pass
			pass
		GameState.PAUSED:
			pass
		GameState.END_CUTSCENE:
			camera.position = Vector2.ZERO
			pass
	pass
	
	#if screens[GameScreen.PASTOR] == null:
		#get_tree().paused = true
	
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
		enemy.add_status_effect(SE_Invincibility.new(enemy, 4))
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
	load_current_game_ui()
	show_pastor(PastorScreen.PastorState.INTRO, true)
	pass
	
func spawn_pastor():
	if skipPastor:
		return
	if timesPastorVisited == 1:
		show_pastor(PastorScreen.PastorState.SHOWING_ITEMS, true)
	else:
		show_pastor(PastorScreen.PastorState.SHOWING_ITEMS, false)
	pass
	
func start_game_skip_pastor():
	unload_all_screens() #SCREEN
	change_state(GameState.PLAYING)
	load_level(currentLvlIndex)
	load_current_game_ui()
	player.allowInput = true
	timesPastorVisited += 1
	pass
	
	
	
func freeze_enemies():
	if get_tree().get_node_count_in_group("enemies") > 0:
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.add_status_effect(SE_MovementSlow.new(enemy, 999999999, 0))
	pass

func unfreeze_enemies():
	if get_tree().get_node_count_in_group("enemies") > 0:
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			for effect in enemy.statusEffects:
				if effect is SE_MovementSlow:
					if effect.TIME_APPLIED == 999999999:
						effect.queue_free()
						continue
					pass
	pass
	
func show_pastor(pstate: PastorScreen.PastorState = PastorScreen.PastorState.SHOWING_ITEMS, hasTutorial: bool = false):
	unload_all_screens()
	load_screen(GameScreen.PASTOR) #SCREEN
	screens[GameScreen.PASTOR].setup(pstate, hasTutorial)
	screens[GameScreen.PASTOR].reparent(camera, false)
	
	player.allowInput = false
	timesPastorVisited += 1
	
	get_tree().paused = true
	player.inputVector = Vector2.ZERO
	hideControls.emit()
	pass
	
func pastor_done():
	get_tree().paused = false
	load_current_game_ui()
	player.allowInput = true
	#unfreeze_enemies()
	showControls.emit()
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
	load_player_input_handler(player)
	
	player.gender = chosenGender
	player.canMove = canPlayerMove
	currentLvl.add_child(player)
	player.justDied.connect(load_death_screen)
	
	pass	
	
func load_player_input_handler(player: Player):
	var inputHandler: InputHandler = inputHandlerScene.instantiate()
	player.add_child(inputHandler)
	player.inputHandler = inputHandler
	inputHandler.target = player
	inputHandler.inputDash.connect(player.dash)
	inputHandler.inputDrop.connect(player.drop_key)
	inputHandler.inputInteract.connect(player.interact)
	inputHandler.inputShootPressed.connect(player.use_weapon)
	inputHandler.inputShootReleased.connect(player.stop_use_weapon)
	
	inputHandler.set_input_method(selectedGameInput)
	
	inputHandler.inputSet.connect(controls_chosen)
	
	hideControls.connect(inputHandler.unload_controls)
	showControls.connect(inputHandler.load_controls)
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
	unload_current_game_ui()
	for key in screens:
		if screens[key] != null:
			screens[key].queue_free()

func try_again():
	unload_all_screens() #SCREEN
	player.score = 0
	player.current_health = player.BASE_TOTAL_HEALTH
	player.isDead = false
	player.wasKilledLastFrame = false
	load_level(currentLvlIndex)
	load_current_game_ui()
	camera.includeMouseMovement = true
	player.allowInput = true
	pass
	
func quit():
	get_tree().quit()
	pass
	
func unload_level():
	currentLvl.queue_free()
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
