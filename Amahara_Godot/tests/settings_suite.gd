extends Node

func run(game) -> void:
	var checks: Array = []
	var original_music: float = game.audio.music_volume
	var original_sfx: float = game.audio.sfx_volume
	var original_vibration: bool = game.vibration
	game.audio.set_music_volume(.23)
	game.audio.sfx_volume = .42
	game.vibration = false
	game.persist_settings()
	var loaded: Dictionary = game.load_settings()
	checks.append({"id":"settings_disk_roundtrip","pass":is_equal_approx(loaded.music,.23) and is_equal_approx(loaded.sfx,.42) and not loaded.vibration})
	game.audio.set_music_volume(original_music)
	game.audio.sfx_volume = original_sfx
	game.vibration = original_vibration
	game.persist_settings()
	var frames: SpriteFrames = game.player.sprite.sprite_frames
	var valid := true
	for dir in ["down","left","right","up"]:
		for pose in ["idle","walk","windup","slash","reverse","finish","hurt","dash","cast","death"]:
			valid = valid and frames.has_animation(pose+"_"+dir)
		valid = valid and frames.get_frame_count("death_"+dir) == 2 and not frames.get_animation_loop("death_"+dir)
	checks.append({"id":"directional_actions_and_death","pass":valid})
	game.ui.show_controls()
	checks.append({"id":"controls_keyboard_focus","pass":get_viewport().gui_get_focus_owner() is Button})
	game.ui.clear_modal()
	game.ui.show_options()
	checks.append({"id":"options_keyboard_focus","pass":get_viewport().gui_get_focus_owner() is HSlider})
	var payload := {"version":2,"stage":6,"checkpoint":"sanctuary","upgrades":[],"completed":["village"],"shortcut":false}
	checks.append({"id":"reject_out_of_order_progress","pass":not SaveStore.validate(payload)})
	payload.stage = 2
	payload.checkpoint = "village"
	payload.upgrades = ["altar","altar"]
	checks.append({"id":"reject_duplicate_upgrade","pass":not SaveStore.validate(payload)})
	var file := FileAccess.open(game.evidence_dir+"/settings_qa.json",FileAccess.WRITE)
	var fail := checks.filter(func(c): return not c.pass).size()
	file.store_string(JSON.stringify({"pass":checks.size()-fail,"fail":fail,"checks":checks},"\t"))
	file.close()
	print("SETTINGS_QA ",checks.size()-fail," PASS / ",fail," FAIL")
	game.close_game(1 if fail else 0)
