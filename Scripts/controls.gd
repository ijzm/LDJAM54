extends Node

var actions = {
	"Move_Up": "Up",
	"Move_Left": "Left",
	"Move_Down": "Down",
	"Move_Right": "Right",
	"Move_Drop": "Drop",
	"Move_Rotate_Clockwise": "Rotate CW",
	"Move_Rotate_Counter_Clockwise": "Rotate CCW",
}

var config = ConfigFile.new()

var control_key: PackedScene = preload("res://Prefabs/Control_Key.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in actions.keys():
		var control_key_instance = control_key.instantiate()
		$CanvasLayer/VBoxContainer.add_child(control_key_instance)
		control_key_instance.start(actions[i], i)


func _on_menu_pressed():
	for i in actions.keys():
		config.set_value("controls", i, InputMap.action_get_events(i)[0])
	
	config.save("user://config.cfg")


	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
