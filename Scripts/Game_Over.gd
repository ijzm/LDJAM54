extends Node

func _ready():
	$CanvasLayer/VBoxContainer/VBoxContainer/Score_Label.set_text("Score: %d" % Globals.score)

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Levels/game.tscn")


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			get_tree().change_scene_to_file("res://Levels/game.tscn")
