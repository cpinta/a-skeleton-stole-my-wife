extends Interactable
class_name ItemChest

var anim: AnimatedSprite2D
@export var itemScene: PackedScene

var ITEM_POPOUT_SPEED: float = 35

func _ready():
	super._ready()
	anim = $animation
	anim.play("idle")
	anim.connect("animation_finished", anim_done)
	itemScene = load("res://scenes/weapons/wp_pistol.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func setup(item: Item):
	self.item = item
	pass

func _interact(entity: Entity):
	super._interact(entity)
	disable_interact()
	anim.play("open")
	pass
	
func anim_done():
	if anim.animation.get_basename() == "open":
		spawn_item_in_chest()
		queue_free()
		pass

func spawn_item_in_chest():
	var itemSpawn = itemScene.instantiate()
	self.owner.add_child(itemSpawn)
	itemSpawn.global_position = self.global_position
	if itemSpawn.elementHeight.DOES_HEIGHT_USE_GRAVITY:
		itemSpawn.elementHeight.heightVerticalSpeed = ITEM_POPOUT_SPEED
		itemSpawn.elementHeight.height
	pass
		

func spawn_entity(index: int):
	pass
