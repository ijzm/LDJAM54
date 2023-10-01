extends Node

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://config.cfg")
	if err != OK:
		return

	var keys = config.get_section_keys("controls")
	for key in keys:
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key, config.get_value("controls", key))

func _on_button_5x5_pressed():
	Globals.BOARD_SIZE = Vector2(5, 5)
	get_tree().change_scene_to_file("res://Levels/game.tscn")
	
func _on_button_7x7_pressed():
	Globals.BOARD_SIZE = Vector2(7, 7)
	get_tree().change_scene_to_file("res://Levels/game.tscn")


func _on_button_custom_pressed():
	var size = int($CanvasLayer/TextEdit.text)

	Globals.BOARD_SIZE = Vector2(size, size)
	get_tree().change_scene_to_file("res://Levels/game.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://Levels/controls.tscn")
