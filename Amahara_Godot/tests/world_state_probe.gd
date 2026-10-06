extends SceneTree

func _initialize() -> void:
	var out := ""
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--evidence-dir="): out = arg.trim_prefix("--evidence-dir=")
	if out.is_empty(): quit(2); return
	var state := SaveStore.read_world(out+"/foundation_world.json")
	var ok: bool = PersistentWorldState.validate(state) and state.get("checkpoint") == "checkpoint.fixture.start" and "boss.fixture.one" in state.get("completed",[])
	var f := FileAccess.open(out+"/foundation_reopen.json",FileAccess.WRITE)
	f.store_string(JSON.stringify({"pass":ok,"method":"Separate OS process, WorldState v3 disk read"},"\t"))
	f.close()
	print("FOUNDATION_REOPEN ",ok)
	quit(0 if ok else 1)
