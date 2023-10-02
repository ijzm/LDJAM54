class_name Laser
extends Node2D

@export var stage: int = 3
@export var pos: int
@export var dir: String

func set_animation_frame():
	print(Globals.LASER_TETROMINO_INTERVAL - stage)
	$AnimatedSprite2D.play(
		str(
			clamp(
				Globals.LASER_TETROMINO_INTERVAL - stage,
				0,
				Globals.LASER_TETROMINO_INTERVAL
			)
		)
	)