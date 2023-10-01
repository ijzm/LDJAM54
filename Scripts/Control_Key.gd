extends HBoxContainer

var action_name = "Up"
var action = "Move_Up"
var edited = false

func start(new_action_name, new_action):
	action_name = new_action_name
	action = new_action

	$Panel/Label.set_text(action_name)
	$Button.set_text(InputMap.action_get_events(action)[0].as_text().split(" ")[0])

func _on_button_pressed():
	$Button.set_text("Press Any Key")
	edited = true

func _input(event):
	if edited and event is InputEventKey and event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		$Button.set_text(event.as_text().split(" ")[0])

		edited = false

