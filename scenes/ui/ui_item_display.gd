extends Control

var parent_Weapon0: Control
var parent_Weapon0cntr: Control
var Weapon0: Weapon
var lblWeapon0: Label
var parent_Weapon1: Control
var parent_Weapon1cntr: Control
var Weapon1: Weapon
var lblWeapon1: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	
	parent_Weapon0 = $"HBoxContainer/Weapon 0"
	parent_Weapon1 = $"HBoxContainer/Weapon 1"
	parent_Weapon0.visible = false
	parent_Weapon1.visible = false
	parent_Weapon0cntr = parent_Weapon0.get_node("Center")
	parent_Weapon1cntr = parent_Weapon1.get_node("Center")
	
	lblWeapon0 = parent_Weapon0.get_node("Name")
	lblWeapon0.text = ""
	lblWeapon1 = parent_Weapon1.get_node("Name")
	lblWeapon1.text = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var wpui_name0: String =  "" if Weapon0 == null else Weapon0.name
	var wp_name0: String = "" if Game.player.weapons[0] == null else Game.player.weapons[0].name
	var wpui_name1: String =  "" if Weapon1 == null else Weapon1.name
	var wp_name1: String = "" if Game.player.weapons[1] == null else Game.player.weapons[1].name
	
	if wp_name0 != wpui_name0:
		if parent_Weapon0cntr.get_child_count() > 0:
			for child in parent_Weapon0cntr.get_children():
				child.queue_free()
				pass
			pass
		if wp_name0 != "":
			Weapon0 = Game.player.weapons[0].duplicate()
			Weapon0.elementHeight.DOES_HEIGHT_USE_GRAVITY = false
			parent_Weapon0cntr.add_child(Weapon0)
			lblWeapon0.text = Weapon0.name
			parent_Weapon0.visible = true
		else:
			parent_Weapon0.visible = false
		pass
	if wp_name1 != wpui_name1:
		if parent_Weapon1cntr.get_child_count() > 0:
			for child in parent_Weapon1cntr.get_children():
				child.queue_free()
				pass
			pass
		if wp_name1 != "":
			Weapon1 = Game.player.weapons[1].duplicate()
			Weapon1.elementHeight.DOES_HEIGHT_USE_GRAVITY = false
			parent_Weapon1cntr.add_child(Weapon1)
			lblWeapon1.text = Weapon1.name
			parent_Weapon1.visible = true
		else:
			parent_Weapon1.visible = false
		pass
	pass
