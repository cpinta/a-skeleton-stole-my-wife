extends Node2D
class_name Interactable

@export var interactArea: Area2D
@export var interactBox: CollisionShape2D

@export var USE_INTERACT_KEY: bool = true
@export var interactKey: UI_ButtonHint
@export var interactKeyVOffset: int = -12

var interactable: bool = true


func _ready():
	
	interactArea = $"interact"
	interactBox = interactArea.get_node("shape")
	
	if USE_INTERACT_KEY:
		var interactKeyScene: PackedScene = load("res://scenes/ui/ui_buttonhint.tscn")
		interactKey = interactKeyScene.instantiate() as UI_ButtonHint
		add_child(interactKey)
		interactKey.setup("interact")
		interactKey.visible = false		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if interactKey != null:
		interactKey.global_position = Vector2(global_position.x, global_position.y - interactKeyVOffset)
	pass

func try_interact(entity: Entity):
	if interactable:
		_interact(entity)
		pass
	pass
	
func _interact(entity: Entity):
	pass

func disable_interact():
	interactable = false
	interactKey.visible = false
	interactBox.disabled = true
	pass

func enable_interact():
	interactable = true
	interactBox.disabled = false
	pass

func is_closest_interact():
	if USE_INTERACT_KEY:
		if interactKey != null:
			interactKey.visible = true
	
func not_closest_interact():
	if interactKey != null:
		interactKey.visible = false
