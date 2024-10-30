extends Node2D
class_name Haze

@export var scoreRequirement = 100

var staticBody: StaticBody2D
var polygon: Polygon2D

var clearing: bool = false

signal started_clearing(int)

# Called when the node enters the scene tree for the first time.
func _ready():
	staticBody = $Polygon2D/StaticBody2D
	polygon = $Polygon2D
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clearing: 
		if polygon.modulate.a > 0:
			polygon.modulate.a -= delta
		else:
			queue_free()
	else:
		check_score()
	pass

func check_score():
	if Game.player != null:
		if Game.player.score > scoreRequirement:
			started_clearing.emit(scoreRequirement)
			clearing = true
