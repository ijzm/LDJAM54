extends Node2D

var rng = RandomNumberGenerator.new()

@onready var board: Board = $Board
@onready var camera: Camera2D = $Game_Camera
@onready var sounds: Sounds = $Sounds

var next_shape
var next_color

var unlocked_powerups = ["p", "b"]
var next_tetromino: Tetromino
var tetromino: Tetromino
var current_tetromino: Current_Tetromino
var current_lasers = []
var current_laser_walls = {}
var timer = Timer.new()


var do_drop: bool = false
var finished_moving: bool = true

var score: int = 0
var money: int = 0
var piece_number: int = 0
var tetromino_number: int = 0
var shop_counter: int = 0

var default_pos = Vector2(-205, 50)
var next_pos = Vector2(-205, -10)

signal update_ui(values)

func test():
	pass

func generate_laser():
	var laser_instance = Globals.laser_ps.instantiate()
	laser_instance.stage = Globals.MAX_LASER_STAGE

	board.add_child(laser_instance)

	var directions = ["h", "v"]

	laser_instance.dir = directions[randi() % directions.size()]
	laser_instance.pos = rng.randi_range(0, (board.height if laser_instance.dir == "h" else board.width) - 1)

	if laser_instance.dir == "h":
		laser_instance.set_position(
			Vector2(-1, laser_instance.pos) * Globals.SIZE
		)
		if(laser_instance.pos+1 < board.height):
			init_no_laser("h", laser_instance.pos+1, laser_instance)
	else:
		laser_instance.set_position(
			Vector2(laser_instance.pos, -1) * Globals.SIZE
		)
		laser_instance.set_rotation(PI / 2)
		init_no_laser("v", laser_instance.pos-1, laser_instance)

	current_lasers.append(laser_instance)
	

func update_lasers():
	var to_delete = []
	var delete_laser_walls = false
	for i in current_lasers:
		add_tweens(i)

		i.stage -= 1

		if i.stage == -1:
			var laser_bullet_instance = Globals.laser_bullet_ps.instantiate()
			add_child(laser_bullet_instance)
			laser_bullet_instance.set_global_position(i.get_global_position())
			if i.dir != "h":
				laser_bullet_instance.set_rotation(PI / 2)

			delete_line(i)
			to_delete.append(i)

		i.set_animation_frame()
			
	if len(to_delete) > 0:
		sounds.play_Laser()

	for i in to_delete:
		current_lasers.erase(i)
		i.queue_free()
		if(current_laser_walls.has(i)):
			current_laser_walls[i].queue_free()
			current_laser_walls.erase(i)
			i.queue_free()

func get_random_location():
	var loc = Vector2(
		rng.randi_range(0, len(next_shape[0]) - 1),
		rng.randi_range(0, len(next_shape) - 1),
	)

	if next_shape[loc.y][loc.x] != "0":
		return loc

	return get_random_location()

func get_next_piece_powerups():
	for x in range(len(next_shape[0])):
		for y in range(len(next_shape)):
			if next_shape[y][x] != "0":
				next_shape[y][x] = "1"

	for x in range(len(next_shape[0])):
		for y in range(len(next_shape)):
			if next_shape[y][x] == "1":
				
				#TODO: Make Dynamic
				var temp = rng.randf_range(0.0, 1.0)
				if  temp > 0.80:
					var next_powerup = unlocked_powerups[randi() % unlocked_powerups.size()]
					next_shape[y][x] = next_powerup

	
	#TODO: Make Dynamic
	# TODO: I don't know why i need this :<
	#if shop_counter > 7:
	#	shop_counter = 0
	#	var loc = get_random_location()
	#	next_shape[loc.y][loc.x] = "s"
	#else:
	#	for x in range(len(next_shape[0])):
	#		for y in range(len(next_shape)):
	#			if next_shape[y][x] == "s":
	#				next_shape[y][x] = "1"


func get_next_tetromino():
	next_shape = Globals.SHAPES[randi() % Globals.SHAPES.size()]
	get_next_piece_powerups()
	
	var colors = Globals.COLORS
	next_color = colors[randi() % colors.size()]


func game_step():
	#Create the Display Tetromino
	if next_tetromino is Tetromino:
		tetromino = next_tetromino
		next_tetromino = null
	else:
		tetromino = generate_tetromino(next_shape, next_color)
		add_child(tetromino)

	tetromino.set_global_position(default_pos)
	tetromino.set_scale(Vector2(0.8, 0.8))

	#Creates the Playable Tetromino
	current_tetromino = generate_current_tetromino(tetromino)
	current_tetromino.pos = Vector2(
		board.width/2 - 1,
		board.height/2 - 1
	)
	var current_tetromino_initial_position = current_tetromino.pos * Globals.SIZE
	board.add_child(current_tetromino)
	current_tetromino.set_position(
		current_tetromino_initial_position
	)

	#Creates the Display Next Tetromino
	get_next_tetromino()
	next_tetromino = generate_tetromino(next_shape, next_color)
	add_child(next_tetromino)
	next_tetromino.set_global_position(next_pos)
	next_tetromino.set_scale(Vector2(0.8, 0.8))

	#Updates Lasers
	update_lasers()

func add_score(n: int):
	score += n
	money +=n

	update_ui.emit({
		"score": score,
	})



func delete_piece(piece: Piece):
	match piece.powerup:
		"b":
			var bomb_explosion_instance = Globals.bomb_explosion_ps.instantiate()
			board.add_child(bomb_explosion_instance)
			bomb_explosion_instance.set_global_position(piece.get_global_position())
			bomb_explosion_instance.name += "Bomb Explosion"

			var delete_positions = []
			for x in range(piece.pos.x - 1, piece.pos.x + 1):
				for y in range(piece.pos.y - 1, piece.pos.y + 1):
					if str(Vector2(x, y)) == str(piece.pos):
						continue

					delete_positions.append(str(Vector2(x, y)))

			for i in board.get_children():
				if i == piece:
					continue

				if i is Piece:
					if str(i.pos) in delete_positions:
						delete_piece(i)
		"p":
			add_score(3)

	add_score(1)
	

	piece.queue_free()

func add_tweens(laser: Laser):
	var board_pieces = []
	var pieces_to_tween = []

	for i in board.get_children():
		if i is Piece:
			board_pieces.append(i)

	if laser.dir == "h":
		for i in board_pieces:
			if i.pos.y == laser.pos:
				pieces_to_tween.append(i)
	else:
		for i in board_pieces:
			if i.pos.x == laser.pos:
				pieces_to_tween.append(i)

	for i in pieces_to_tween:
		var t = i.get_node("Sprite2D")
		#var start_color = t.get_modulate()
		
		var tween = t.create_tween()
		tween.tween_property(
			t,
			"modulate",
			Color.from_string("#808080", Color.GRAY),
			0.5
		)
		#tween.tween_property(
		#	t,
		#	"modulate",
		#	start_color,
		#	0.5
		#)
		tween.set_trans(Tween.TRANS_QUINT)
		tween.set_ease(Tween.EASE_IN_OUT)
		#tween.set_loops()

func delete_line(laser: Laser):
	var board_pieces = []
	var scored = false

	for i in board.get_children():
		if i is Piece:
			board_pieces.append(i)

	if laser.dir == "h":
		for i in board_pieces:
			if i.pos.y == laser.pos:
				delete_piece(i)
				scored = true
	else:
		for i in board_pieces:
			if i.pos.x == laser.pos:
				delete_piece(i)
				scored = true

	if scored:
		pass
		#sounds.play_score()


func init_board():
	board.generate_board(Globals.BOARD_SIZE)

	Globals.SIZE = Vector2(
		board.get_child(0).texture.get_width(),
		board.get_child(0).texture.get_height(),
	)

	board.set_global_position(Vector2(
		-(board.width * Globals.SIZE.x)/2,
		-(board.height * Globals.SIZE.y)/2
	))

	var clipping_mask: Sprite2D = $Canvas_Group/Clip_Mask

	clipping_mask.set_global_position(
		board.get_global_position() + Vector2(
			-Globals.SIZE.x/2,
			-Globals.SIZE.y/2,
		)
	)

	clipping_mask.get_texture().set_size(Vector2(
		board.width * Globals.SIZE.x,
		board.height * Globals.SIZE.y 
	))

	for i in range(board.width):
		init_no_laser("v", i)

	for i in range(board.height):
		init_no_laser("h", i)

func init_no_laser(dir, pos, connected_laser=null):
	var no_laser_tile_instance = Globals.no_laser_tile_ps.instantiate()
	board.add_child(no_laser_tile_instance)

	if dir == "h":
		no_laser_tile_instance.set_position(
			Vector2(-1, pos) * Globals.SIZE
		)
	else:
		no_laser_tile_instance.set_position(
			Vector2(pos, -1) * Globals.SIZE
		)
		no_laser_tile_instance.set_rotation(PI / 2)
		
	if(connected_laser != null):
		var new_texture = load("res://Graphics//No_Laser_Wall_Tile.png") # Load the new texture.
		no_laser_tile_instance.set_texture(new_texture)
		current_laser_walls[connected_laser] = no_laser_tile_instance
		

func init_timer():
	timer.connect("timeout", force_drop)
	timer.wait_time = Globals.FALL_TIME
	timer.one_shot = true
	add_child(timer)
	timer.start()

func init_powerups():
	unlocked_powerups = ["b", "p"]

func reset_counters():
	score = 0
	money = 0
	piece_number = 0
	tetromino_number = 0
	shop_counter = 0

func init():
	reset_counters()
	init_board()
	get_next_tetromino()
	game_step()
	
	var num = randi_range(1, 6)
	for i in range(num):
		generate_laser()

	update_ui.emit({
		"score": score,
		"piece_number": piece_number,
		"tetromino_number": tetromino_number,
		"shop_counter": shop_counter,
	})

	init_timer()
	init_powerups()

func _ready():
	init()

func force_drop():
	if check_valid_position() == false:
		Globals.score = score
		get_tree().change_scene_to_file("res://Levels/game_over.tscn")
	else:
		do_drop = true

func generate_tetromino(shape, color):
	var output = Globals.tetromino_ps.instantiate()
	output.generate_shape(shape, color)
	return output

func generate_current_tetromino(src: Tetromino):
	var output = Globals.current_tetromino_ps.instantiate()
	output.tetromino = src
	output.generate_shape(src.shape, 0)

	output.name = "Current_Tetromino"
	return output

func _process(_delta):
	if do_drop and finished_moving:
		drop_current_tetromino()
		do_drop = false

func update_finished_moving():
	finished_moving = true

func update_current_tetromino_position():
	var new_pos = Vector2(
		clamp(current_tetromino.pos.x, 0, board.width - current_tetromino.tetromino.width),
		clamp(current_tetromino.pos.y, 0, board.height - current_tetromino.tetromino.height)
	)
	if current_tetromino.pos != new_pos:
		current_tetromino.pos = new_pos
		return

	finished_moving = false

	var tween = current_tetromino.create_tween()
	tween.tween_property(
		current_tetromino,
		"position",
		(current_tetromino.pos * Globals.SIZE),
		0.05
	)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(update_finished_moving)

func move_current_tetromino(direction: Vector2):
	current_tetromino.pos += direction
	update_current_tetromino_position()

func check_valid_position():
	tetromino.set_global_position(current_tetromino.get_global_position())
	tetromino.set_scale(Vector2.ONE)

	var board_pieces = []
	var board_positions = []
	
	for i in board.get_children():
		if i is Piece:
			board_pieces.append(i)

	for i in board_pieces:
		board_positions.append(str(i.pos))

	var tetromino_positions = []
	for i in tetromino.get_children():
		var pos = (i.get_global_position() - board.get_global_position()) / Globals.SIZE
		tetromino_positions.append(str(pos))

	for i in tetromino_positions:
		if i in board_positions:
			tetromino.set_global_position(default_pos)
			tetromino.set_scale(Vector2(0.8, 0.8))
			return false

	return true

func drop_current_tetromino():
	if check_valid_position() == false:
		sounds.play_No_Place_Block()
		return

	sounds.play_Place()

	tetromino.set_global_position(current_tetromino.get_global_position())
	
	tetromino_number += 1
	shop_counter += 1
	piece_number += len(tetromino.get_children())

	if tetromino_number % Globals.LASER_TETROMINO_INTERVAL == 0:
		var num = randi_range(1, 6)
		for i in range(num):
			generate_laser()

	for i in tetromino.get_children():
		i.pos = (i.get_global_position() - board.get_global_position()) / Globals.SIZE
		tetromino.remove_child(i)
		board.add_child(i)
		i.set_position(i.pos * Globals.SIZE)

	#Kills Shadows
	for i in $Canvas_Group/Clip_Mask.get_children():
		i.queue_free()
	finished_moving = true

	current_tetromino.queue_free()
	tetromino.queue_free()

	game_step()
	timer.start()

func _input(event):
	if event.is_action_pressed("Move_Up"):
		move_current_tetromino(Vector2.UP)

	if event.is_action_pressed("Move_Left"):
		move_current_tetromino(Vector2.LEFT)

	if event.is_action_pressed("Move_Down"):
		move_current_tetromino(Vector2.DOWN)

	if event.is_action_pressed("Move_Right"):
		move_current_tetromino(Vector2.RIGHT)

	if event.is_action_pressed("Move_Drop"):
		do_drop = true

	if event.is_action_pressed("Move_Rotate_Clockwise"):
		sounds.play_Rotate()
		current_tetromino.rotate_clockwise(Globals.FALL_TIME - timer.time_left)

		current_tetromino.pos = Vector2(
			clamp(current_tetromino.pos.x, 0, board.width - current_tetromino.tetromino.width),
			clamp(current_tetromino.pos.y, 0, board.height - current_tetromino.tetromino.height)
		)

		current_tetromino.set_position(current_tetromino.pos * Globals.SIZE)

	if event.is_action_pressed("Move_Rotate_Counter_Clockwise"):
		sounds.play_Rotate()
		current_tetromino.rotate_counter_clockwise(Globals.FALL_TIME - timer.time_left)

		current_tetromino.pos = Vector2(
			clamp(current_tetromino.pos.x, 0, board.width - current_tetromino.tetromino.width),
			clamp(current_tetromino.pos.y, 0, board.height - current_tetromino.tetromino.height)
		)
		
		current_tetromino.set_position(current_tetromino.pos * Globals.SIZE)
