extends Control
class_name UI_Weapon

var CenterPos: Control
var WeaponScene: Weapon
var lblWeapon: Label

var cooldownProgress: UI_Cooldown
var ammoCount: UI_Ammo_Count

var touchButton: TouchScreenButton

@export var playerWeaponIndex: int

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	CenterPos = get_node("Center")
	lblWeapon = get_node("Name")
	lblWeapon.text = ""
	cooldownProgress = $UpperPart/CooldownProgress
	cooldownProgress.setup(playerWeaponIndex)
	
	ammoCount = $"UpperPart/ammo count"
	ammoCount.setup(playerWeaponIndex)
	
	touchButton = $Control/touchbutton
	touchButton.released.connect(switch_to_this_weapon)
	
	if playerWeaponIndex == 0:
		$"UpperPart/input icon/sprite".texture = load("res://sprites/ui/mouse_left_click.png")
	elif playerWeaponIndex == 1:
		$"UpperPart/input icon/sprite".texture = load("res://sprites/ui/mouse_right_click.png")
	pass # Replace with function body.

func switch_to_this_weapon():
	if WeaponScene != null:
		if Game.player != null:
			if Game.player.currentHand != playerWeaponIndex:
				Game.player.swap_weapons()
	pass

func _process(delta):
	if Game.player == null:
		return
	var wpui_name: String =  "" if WeaponScene == null else WeaponScene.weaponName
	var wp_name: String = "" if Game.player.weapons[playerWeaponIndex] == null else Game.player.weapons[playerWeaponIndex].weaponName
	
	if wp_name != wpui_name:
		if CenterPos.get_child_count() > 0:
			for child in CenterPos.get_children():
				child.queue_free()
				pass
			pass
		if wp_name != "":
			WeaponScene = Game.player.weapons[playerWeaponIndex].duplicate()
			WeaponScene.elementHeight.DOES_HEIGHT_USE_GRAVITY = false
			WeaponScene.USE_INTERACT_KEY = false
			WeaponScene.interactKey.queue_free()
			CenterPos.add_child(WeaponScene)
			WeaponScene.elementHeight.unload_shadow()
			lblWeapon.text = wp_name
			visible = true
		else:
			visible = false
		pass
	pass
