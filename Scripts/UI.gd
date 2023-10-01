extends CanvasLayer

func _on_game_manager_update_ui(values):
	if "score" in values:
		$HBoxContainer/VBoxContainer/Score/Score_Label.set_text(
			"Score: %06d" % values["score"]
		)
