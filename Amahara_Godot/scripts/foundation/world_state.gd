class_name PersistentWorldState
extends RefCounted

const VERSION := 3
const NAMESPACE := "dark.kuroyomi"
var flags: Dictionary = {}
var completed: Array = []
var unlocked: Array = []
var upgrades: Array = []
var progress: Dictionary = {}
var checkpoint: String = ""

func snapshot() -> Dictionary:
	return {"version":VERSION, "namespace":NAMESPACE, "flags":flags.duplicate(true), "completed":completed.duplicate(), "unlocked":unlocked.duplicate(), "upgrades":upgrades.duplicate(), "progress":progress.duplicate(true), "checkpoint":checkpoint}

static func validate(data: Variant) -> bool:
	if not data is Dictionary or data.get("version") != VERSION or data.get("namespace") != NAMESPACE: return false
	if data.size() != 8: return false
	if not data.get("checkpoint") is String: return false
	if data.checkpoint != "" and (not PersistentIds.valid(data.checkpoint) or not data.checkpoint.begins_with("checkpoint.")): return false
	for key in ["flags", "progress"]:
		if not data.get(key) is Dictionary: return false
		for id in data[key]:
			if not PersistentIds.valid(id): return false
			var value = data[key][id]
			if key == "flags" and not value is bool: return false
			if key == "progress":
				if not (value is int or value is float): return false
				if not is_finite(float(value)) or value < 0 or value != int(value): return false
	for key in ["completed", "unlocked", "upgrades"]:
		if not data.get(key) is Array: return false
		var seen := {}
		for id in data[key]:
			if not PersistentIds.valid(id) or seen.has(id): return false
			seen[id] = true
	return true

func restore(data: Variant) -> bool:
	if not validate(data): return false
	flags = data.flags.duplicate(true)
	completed = data.completed.duplicate()
	unlocked = data.unlocked.duplicate()
	upgrades = data.upgrades.duplicate()
	progress = data.progress.duplicate(true)
	checkpoint = data.checkpoint
	return true
