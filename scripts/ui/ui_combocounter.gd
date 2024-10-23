extends Control

var lblComboTxt: RichTextLabel
var lblComboNum: Label
var ComboBar: ProgressBar

var BASE_NUM_SCALE: float = 1
var NEW_NUM_SCALE: float = 2
var NUM_SCALE_CHANGE: float = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	lblComboTxt = $"combo text"
	lblComboNum = $"combo num"
	ComboBar = $"combo bar"
	
	#Game.player.combo.combo_point_added.connect(combo_added)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lblComboTxt.text = "[center][b]COMBO[/b][/center]"
	
	if Game.player != null:
		if not Game.player.combo.combo_point_added.is_connected(combo_added):
			Game.player.combo.combo_point_added.connect(combo_added)
			ComboBar.max_value = Game.player.combo.COMBO_TIME
		lblComboNum.text = str(Game.player.combo.comboCount)
		ComboBar.value = Game.player.combo.comboTimer
		if Game.player.combo.comboCount > 0:
			self.visible = true
			if lblComboNum.scale.x > BASE_NUM_SCALE:
				lblComboNum.scale -= Vector2.ONE * NUM_SCALE_CHANGE * delta
			else:
				lblComboNum.scale = Vector2.ONE * BASE_NUM_SCALE
			pass
		else:
			self.visible = false

func combo_added():
	lblComboNum.scale = Vector2.ONE * NEW_NUM_SCALE
	pass
