class_name Piece
extends Node2D

@export var pos: Vector2
@export var color: String = ""
@export var powerup: String = ""

func set_color(new_color: String):
	color = new_color
	$Sprite2D.set_modulate(Globals.COLORS.get(color, Color.WHITE))

func set_powerup(new_powerup: String):
	powerup = new_powerup
	if powerup == "0" or powerup == "1": return
	var powerup_instance = Globals.powerups_ps[powerup].instantiate()
	add_child(powerup_instance)
