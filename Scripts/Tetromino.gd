class_name Tetromino
extends Node2D

var shape
var width: int
var height: int
var color: String
var pos: Vector2

func generate_shape(new_shape, new_color):
	shape = new_shape
	width = len(shape[0])
	height = len(shape)

	color = new_color

	for x in range(width):
		for y in range(height):
			if shape[y][x] != "0":
				var piece_instance = Globals.piece_ps.instantiate()
				piece_instance.set_color(color)
				piece_instance.set_powerup(shape[y][x])

				add_child(piece_instance)

				piece_instance.set_position(Vector2(
					x * Globals.SIZE.x,
					y * Globals.SIZE.y
				))

#I guess this could be optized
func transpose():
	var new_width = len(shape)
	var new_height = len(shape[0])

	var output = []

	for i in range(new_height):
		var line = ""
		for j in range(new_width):
			line += "0"

		output.append(line)

	for x in range(width):
		for y in range(height):
			output[x][y] = shape[y][x]

	width = new_width
	height = new_height
	return output

#https://stackoverflow.com/questions/42519/how-do-you-rotate-a-two-dimensional-array
func rotate_clockwise():
	var new_shape = transpose()

	for i in range(len(new_shape)):

		var inverted_string = []
		for j in new_shape[i]:
			inverted_string.append(j)

		inverted_string.reverse()

		var inverted = ""
		for j in inverted_string:
			inverted += j

		new_shape[i] = inverted
	
	shape = new_shape

	for i in get_children():
		i.queue_free()

	generate_shape(new_shape, color)

func rotate_counter_clockwise():
	var new_shape = transpose()

	new_shape.reverse()
	
	shape = new_shape

	for i in get_children():
		i.queue_free()

	generate_shape(new_shape, color)
