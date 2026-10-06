class_name InputConfig
extends RefCounted

static func install() -> void:
	var actions := {
		"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP], "move_down": [KEY_S, KEY_DOWN],
		"attack_light": [KEY_J], "attack_heavy": [KEY_K], "dash": [KEY_SPACE],
		"magic_1": [KEY_Q], "magic_2": [KEY_E], "interact": [KEY_F], "pause": [KEY_ESCAPE]
	}
	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action, 0.2)
		for code in actions[action]:
			var key := InputEventKey.new()
			key.physical_keycode = code
			InputMap.action_add_event(action, key)
	var buttons := {"attack_light": JOY_BUTTON_X, "attack_heavy": JOY_BUTTON_Y,
		"dash": JOY_BUTTON_B, "magic_1": JOY_BUTTON_LEFT_SHOULDER,
		"magic_2": JOY_BUTTON_RIGHT_SHOULDER, "interact": JOY_BUTTON_A,
		"pause": JOY_BUTTON_START, "move_left": JOY_BUTTON_DPAD_LEFT,
		"move_right": JOY_BUTTON_DPAD_RIGHT, "move_up": JOY_BUTTON_DPAD_UP,
		"move_down": JOY_BUTTON_DPAD_DOWN}
	for action in buttons:
		var button := InputEventJoypadButton.new()
		button.button_index = buttons[action]
		InputMap.action_add_event(action, button)
	for pair in [["move_left", 0, -1.0], ["move_right", 0, 1.0], ["move_up", 1, -1.0], ["move_down", 1, 1.0]]:
		var motion := InputEventJoypadMotion.new()
		motion.axis = pair[1]
		motion.axis_value = pair[2]
		InputMap.action_add_event(pair[0], motion)

static func movement() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
