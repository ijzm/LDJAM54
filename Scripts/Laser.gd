class_name Laser
extends Node2D

@export var stage: int = 3
@export var pos: int
@export var dir: String

func _process(_delta):
	$Sprite2D.frame = clampi($Sprite2D.hframes - stage - 1, 0, $Sprite2D.hframes - 1)
