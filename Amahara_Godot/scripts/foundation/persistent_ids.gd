class_name PersistentIds
extends RefCounted

const KINDS := ["region", "checkpoint", "boss", "shortcut", "quest", "npc", "magic", "upgrade", "map", "secret", "flag", "story", "encounter"]
var claimed: Dictionary = {}

static func valid(value: Variant) -> bool:
	if not value is String or value.length() > 128: return false
	var parts: PackedStringArray = value.split(".")
	if parts.size() < 2 or parts[0] not in KINDS: return false
	var pattern := RegEx.new()
	pattern.compile("^[a-z][a-z0-9_]*$")
	for part in parts:
		if pattern.search(part) == null: return false
	return true

func claim(id: String) -> bool:
	if not valid(id) or claimed.has(id): return false
	claimed[id] = true
	return true
