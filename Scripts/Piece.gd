class_name Piece
extends Node2D

@export var pos: Vector2
@export var color: String = ""
@export var powerup: String = ""

func set_color(new_color: String):
	color = new_color
	var new_texture = load("res://Graphics//"+ color + "_Piece.png") # Load the new texture.
	$Sprite2D.set_texture(new_texture)

func set_powerup(new_powerup: String):
	powerup = new_powerup
	if powerup == "0" or powerup == "1": return
	var powerup_instance = Globals.powerups_ps[powerup].instantiate()
	add_child(powerup_instance)
