class_name Current_Tetromino
extends Node2D

var tetromino: Tetromino
var pos: Vector2

func generate_shape(shape, timer):
	for x in range(len(shape[0])):
		for y in range(len(shape)):
			if shape[y][x] != "0":
				var piece_instance = Globals.current_piece_ps.instantiate()
				piece_instance.timer = timer
				piece_instance.set_powerup(shape[y][x])
				add_child(piece_instance)

				piece_instance.set_position(Vector2(
					x * Globals.SIZE.x,
					y * Globals.SIZE.y
				))


func rotate_tetromino(timer):
	for i in get_children():
		i.kill_shadow()

	generate_shape(tetromino.shape, timer)

func rotate_clockwise(timer):
	tetromino.rotate_clockwise()
	rotate_tetromino(timer)

func rotate_counter_clockwise(timer):
	tetromino.rotate_counter_clockwise()
	rotate_tetromino(timer)
