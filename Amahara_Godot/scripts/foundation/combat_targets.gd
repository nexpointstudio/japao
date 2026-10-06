class_name CombatTargetRegistry
extends RefCounted

var entries: Dictionary = {}

func register(actor: Node2D, faction: int) -> void:
	actor.set_meta("combat_faction", faction)
	entries[actor.get_instance_id()] = weakref(actor)

func unregister(actor: Node2D) -> void:
	if is_instance_valid(actor): entries.erase(actor.get_instance_id())

func hostiles(actor: Node2D) -> Array[Node2D]:
	var result: Array[Node2D] = []
	for id in entries.keys():
		var candidate = entries[id].get_ref()
		if not is_instance_valid(candidate):
			entries.erase(id)
			continue
		if candidate.is_queued_for_deletion() or candidate.get("dead") == true: continue
		if CombatFactions.hostile(actor, candidate): result.append(candidate)
	return result

func nearest(actor: Node2D) -> Node2D:
	var found: Node2D
	var distance := INF
	for candidate in hostiles(actor):
		var d := actor.global_position.distance_squared_to(candidate.global_position)
		if d < distance:
			distance = d
			found = candidate
	return found
