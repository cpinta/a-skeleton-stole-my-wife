extends Entity
class_name Enemy

@export var DAMAGE := 1
@export var DAMAGES_ON_CONTACT: bool = false
@export var ONLY_DAMAGES_PLAYER: bool = true

@export var NEVER_SHOW_HEALTH_BAR: bool = false

@export var DAMAGE_APPLIES_HITSTUN: bool = true
@export var HITSUN_SCALES_W_DAMAGE: bool = false
@export var DAMAGE_HITSTUN_MULTIPLIER: float = 0.25

@export var player : Player
@export var target : Entity
@export var FOLLOWS_PLAYER := true
@export var FLIP_TOWARD_PLAYER := true
@export var ATTACKS_HAVE_HITSTUN := true

@export var HAS_TURNING_RADIUS : bool = false
@export var turning_radius: float = 0

@export var hurtbox : Area2D
@export var hurtboxShape : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if get_tree().get_node_count_in_group("player") > 0:
		player = get_tree().get_nodes_in_group("player")[0]
	
	body = $"body"
	hurtbox = body.get_node_or_null("hurtbox")
	if hurtbox != null:
		hurtbox.connect("area_entered", _collided_with_something)
		hurtboxShape = hurtbox.get_node_or_null("shape")
	
	target = player
	
	
	BASE_ATTACK_KNOCKBACK = 100
	
	BASE_MOVEMENT_ACCELERATION = 500
	BASE_MOVEMENT_MAX_SPEED = 10
	
	facingDirection = Direction.LEFT
	check_direction()
	
	if not NEVER_SHOW_HEALTH_BAR:
		var healthbar = load("res://scenes/ui/health_bar.tscn").instantiate()
		self.add_child(healthbar)
		healthbar.setup(self, UI_HealthBar.HealthBarType.MINI)
		pass
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if not check_for_target_or_player():
		return
	if FOLLOWS_PLAYER:
		set_inputVector_toward_target(delta)
		check_direction()
	pass

func _physics_process(delta):
	super._physics_process(delta)
	if not check_for_target_or_player():
		return
	if elementHeight.height > 25: #if flying
		#dont hit player if high up
		rb.collision_layer = 0b0001000
		rb.collision_mask = 0b1001001
		if hurtbox != null:
			hurtbox.collision_layer = 0b0001000
			hurtbox.collision_mask = 0b1001001
		pass
	else: #if on ground
		rb.collision_layer = 0b00000100
		rb.collision_mask = 0b0000111
		if hurtbox != null:
			hurtbox.collision_layer = 0b00000100
			hurtbox.collision_mask = 0b0000111
		pass
		pass
	pass
	
func check_direction():
	if FLIP_TOWARD_PLAYER:
		if facingDirection == Direction.LEFT && inputVector.x > 0:
			set_direction(Direction.RIGHT)
		elif facingDirection == Direction.RIGHT && inputVector.x < 0:
			set_direction(Direction.LEFT)
		
func set_inputVector_toward_target(delta):
	if target == null:
		return
	var targetVector = (target.global_position - global_position).normalized()
	if not HAS_TURNING_RADIUS:
		inputVector = targetVector
	else:
		inputVector =  inputVector.lerp(targetVector, turning_radius * delta)
		print(inputVector)
	inputVector = -Vector2(inputVector.x, inputVector.y)
		
func set_direction(dir: Direction):
	super.set_direction(dir)
	if dir == Direction.LEFT:
		#anim.flip_h = false
		body.scale.y = 1
		body.rotation = 0
	elif dir == Direction.RIGHT:
		#anim.flip_h = true
		body.scale.y = -1
		body.rotation = -PI
	pass

func _collided_with_something(area: Area2D):
	if DAMAGES_ON_CONTACT:
		if area.name == "hurtbox":
			var entity = area.get_parent().get_parent() as Entity
			if entity != null:
				if (ONLY_DAMAGES_PLAYER and entity is Player) or not ONLY_DAMAGES_PLAYER:
					apply_attack_to_entity(entity)
	pass

func apply_attack_to_entity(entity: Entity):
	if DAMAGE_APPLIES_HITSTUN:
		attack_statusEffects = [SE_Hitstun.new(entity, attack_hitstun + (DAMAGE_HITSTUN_MULTIPLIER * attack_damage * int(HITSUN_SCALES_W_DAMAGE)))]
	super.apply_attack_to_entity(entity)
	pass

func check_for_target_or_player():
	if target == null:
		if player == null:
			if get_tree().get_node_count_in_group("player") > 0:
				player = get_tree().get_nodes_in_group("player")[0]
				target = player
			else:
				return false
		else:
			target = player
	return true
	pass
