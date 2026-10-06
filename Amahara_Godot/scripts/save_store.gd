class_name SaveStore
extends RefCounted

const PATH := "user://amahara_save.json"
static var override_path: String = ""
static var recovered_backup := false

static func path() -> String:
	return override_path if not override_path.is_empty() else PATH

static func validate(value: Variant) -> bool:
	if not value is Dictionary or value.get("version",0) != 2: return false
	if not value.get("stage") is float and not value.get("stage") is int: return false
	if value.stage < 0 or value.stage > 6 or value.stage != int(value.stage): return false
	if value.get("checkpoint","") not in ["village","sanctuary"]: return false
	if not value.get("shortcut") is bool: return false
	for key in ["upgrades","completed"]:
		if not value.get(key) is Array: return false
		var seen: Array = []
		for item in value[key]:
			var allowed := ["altar","memorial"] if key == "upgrades" else ["village","forest","bridge","corruption","elite"]
			if not item is String or item not in allowed or item in seen: return false
			seen.append(item)
	if value.stage >= 1 and "village" not in value.completed: return false
	if value.stage >= 4 and value.checkpoint != "sanctuary": return false
	if value.stage >= 5 and "elite" not in value.completed: return false
	return true

static func read_save() -> Dictionary:
	recovered_backup = false
	for candidate in [path(),path()+".bak"]:
		if not FileAccess.file_exists(candidate): continue
		var parser := JSON.new()
		if parser.parse(FileAccess.get_file_as_string(candidate)) != OK: continue
		var value = parser.data
		# The visual-sample save is intentionally migrated only to the village.
		if value is Dictionary and value.get("version",0) == 1 and value.get("cleared") is bool:
			value = {"version":2,"stage":1 if value.cleared else 0,"checkpoint":"village","upgrades":[],"completed":["village"] if value.cleared else [],"shortcut":false}
		if validate(value):
			recovered_backup = candidate.ends_with(".bak")
			return value
	return {}

static func write_save(data: Dictionary) -> bool:
	var payload := data.duplicate(true)
	payload.version = 2
	if not validate(payload): return false
	var file := FileAccess.open(path()+".tmp",FileAccess.WRITE)
	if not file: return false
	file.store_string(JSON.stringify(payload,"\t"))
	file.flush()
	file.close()
	# Never replace a valid backup with a corrupt main file.
	if FileAccess.file_exists(path()):
		var parser := JSON.new()
		if parser.parse(FileAccess.get_file_as_string(path())) == OK and validate(parser.data):
			if DirAccess.copy_absolute(path(),path()+".bak") != OK: return false
	return DirAccess.rename_absolute(path()+".tmp",path()) == OK
