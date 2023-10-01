extends Node

func go_main_menu():
	Globals.start_music()
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")

func _on_audio_stream_player_finished():
	go_main_menu()

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		go_main_menu()