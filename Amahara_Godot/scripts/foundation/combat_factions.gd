class_name CombatFactions
extends RefCounted

enum Team { NEUTRAL, PLAYER, ALLY, ENEMY }
enum Relation { NEUTRAL, FRIENDLY, HOSTILE }

static func of(actor: Node) -> int:
	return int(actor.get_meta("combat_faction", Team.NEUTRAL)) if is_instance_valid(actor) else Team.NEUTRAL

static func relation(a: int, b: int) -> int:
	if a == Team.NEUTRAL or b == Team.NEUTRAL: return Relation.NEUTRAL
	if a == b or (a in [Team.PLAYER, Team.ALLY] and b in [Team.PLAYER, Team.ALLY]): return Relation.FRIENDLY
	return Relation.HOSTILE

static func hostile(a: Node, b: Node) -> bool:
	return is_instance_valid(a) and is_instance_valid(b) and a != b and relation(of(a), of(b)) == Relation.HOSTILE
