extends Node

var score: int = 0

var SIZE: Vector2 = Vector2(16, 16)
var FALL_TIME: float = 3.0
var MAX_LASER_STAGE: int = 3

var BOARD_SIZE: Vector2 = Vector2(5, 5)
var BOARD_COLOR_LIGHT = Color.from_string("#333333", Color.WHITE)
var BOARD_COLOR_DARK = Color.from_string("#1E1E1E", Color.BLACK)

var LASER_TETROMINO_INTERVAL = 3
var SHOP_PIECE_INTERVAL = 15

var COLORS = [
	"RED",
	"GREEN",
	"BLUE",
	"ORANGE",
]

var SHAPES = [
	[
		"100",
		"111"
	],
	[
		"001",
		"111",
	],
	[
		"11",
		"11"
	],
	[
		"010",
		"111"
	],
	[
		"110",
		"011"
	],
	[
		"011",
		"110"
	],
	[
		"1111",
	],
	
]

var board_piece_ps:          PackedScene = preload("res://Prefabs/Board_Piece.tscn")
var current_tetromino_ps:    PackedScene = preload("res://Prefabs/Current_Tetromino.tscn")
var current_piece_ps:        PackedScene = preload("res://Prefabs/Current_Piece.tscn")
var tetromino_ps:            PackedScene = preload("res://Prefabs/Tetromino.tscn")
var piece_ps:                PackedScene = preload("res://Prefabs/Piece.tscn")
var laser_ps:                PackedScene = preload("res://Prefabs/Laser.tscn")
var bomb_explosion_ps:       PackedScene = preload("res://Prefabs/Bomb_Explosion.tscn")
var laser_bullet_ps:         PackedScene = preload("res://Prefabs/Laser_Bullet.tscn")
var current_piece_shadow_ps: PackedScene = preload("res://Prefabs/Current_Piece_Shadow.tscn")

var powerups_ps = {
	"p": preload("res://Prefabs/Powerup_Points.tscn"),
	"b": preload("res://Prefabs/Powerup_Bomb.tscn"),
	"s": preload("res://Prefabs/Powerup_Shop.tscn"),
}

var music: PackedScene = preload("res://Prefabs/Music.tscn")

func start_music():
	var music_instance = music.instantiate()
	add_child(music_instance)