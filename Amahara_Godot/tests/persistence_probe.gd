extends Node

func run(game) -> void:
	if "--verify-world" in OS.get_cmdline_user_args():
		var state := SaveStore.read_world(game.evidence_dir+"/foundation_world.json")
		var valid: bool = PersistentWorldState.validate(state) and state.get("checkpoint") == "checkpoint.fixture.start" and "boss.fixture.one" in state.get("completed",[])
		var result := FileAccess.open(game.evidence_dir+"/foundation_reopen.json",FileAccess.WRITE)
		result.store_string(JSON.stringify({"pass":valid,"method":"Separate packaged process, WorldState v3 disk read"},"\t"))
		result.close()
		print("FOUNDATION_REOPEN ",valid)
		game.close_game(0 if valid else 1)
		return
	var save := SaveStore.read_save()
	game.start_sample(true)
	var ok: bool = save.get("stage",0) == 6 and game.story.stage == 6 and game.player.max_energy == 125 and game.story.upgrades.size() == 2 and game.story.shortcut and not is_instance_valid(game.boss)
	var f := FileAccess.open(game.evidence_dir+"/reopen.json",FileAccess.WRITE)
	f.store_string(JSON.stringify({"pass":ok,"stage":game.story.stage,"upgrades":game.story.upgrades,"max_energy":game.player.max_energy,"method":"New operating-system process reading save left by playthrough"},"\t"))
	f.close()
	print("PROCESS_REOPEN ",ok)
	game.close_game()
