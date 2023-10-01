extends Sprite2D

var timer: float = 3
var shadow
var canvas_group: CanvasGroup

func kill_shadow():
	shadow.queue_free()
	queue_free()

func set_powerup(powerup: String):
	if powerup == "0" or powerup == "1": return
	var powerup_instance = Globals.powerups_ps[powerup].instantiate()
	add_child(powerup_instance)

func _ready():
	shadow = Globals.current_piece_shadow_ps.instantiate()
	canvas_group = get_node("/root/Game/Game_Manager/Canvas_Group")
	canvas_group.add_child(shadow)

	var tween = shadow.create_tween()
	tween.tween_property(
		shadow,
		"scale",
		Vector2(1, 1),
		Globals.FALL_TIME
	)
	tween.tween_callback(kill_shadow)
	tween.custom_step(timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if shadow != null:
		shadow.set_global_position(get_global_position())
