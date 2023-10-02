class_name Board
extends Node2D

var height: int = 7
var width: int = 7

func generate_board(size: Vector2):
	width = int(size.x)
	height = int(size.y)
	for x in range(width):
		for y in range(height):
			var board_piece_instance: Sprite2D = Globals.board_piece_ps.instantiate()
			add_child(board_piece_instance)

			var pos = Vector2(
				x * board_piece_instance.texture.get_width(),
				y * board_piece_instance.texture.get_height()
			)

			board_piece_instance.set_position(pos)

			if (x + y) % 2 == 0:
				var light_texture = load("res://Graphics//Board_Piece_Light.png")
				board_piece_instance.set_texture(light_texture)
			else:
				var dark_texture = load("res://Graphics//Board_Piece_Dark.png")
				board_piece_instance.set_texture(dark_texture)
			
