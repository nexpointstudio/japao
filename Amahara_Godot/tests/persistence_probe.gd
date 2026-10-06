extends Node

func run(game) -> void:
	var save := SaveStore.read_save()
	game.start_sample(true)
	var ok: bool = save.get("stage",0) == 6 and game.story.stage == 6 and game.player.max_energy == 125 and game.story.upgrades.size() == 2 and game.story.shortcut and not is_instance_valid(game.boss)
	var f := FileAccess.open(game.evidence_dir+"/reopen.json",FileAccess.WRITE)
	f.store_string(JSON.stringify({"pass":ok,"stage":game.story.stage,"upgrades":game.story.upgrades,"max_energy":game.player.max_energy,"method":"New operating-system process reading save left by playthrough"},"\t"))
	f.close()
	print("PROCESS_REOPEN ",ok)
	game.close_game()
