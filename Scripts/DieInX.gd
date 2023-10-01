extends Node2D

@export var time: float = 3.

func _timer_callback():
	print("DIE")
	pass
	#self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer: Timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(time)
	timer.connect("timeout", _timer_callback)
	self.add_child(timer)
	timer.start()
