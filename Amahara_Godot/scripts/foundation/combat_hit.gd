class_name CombatHit
extends RefCounted

var origin := Vector2.ZERO
var attacker: Node2D
var target: Node2D
var damage: float = 0
var knockback: float = 0
var stagger: float = 0
var direction := Vector2.ZERO
var damage_type: StringName = &"physical"
var source_kind: StringName = &"melee"
var attack_id: String = ""
var properties: Dictionary = {}

static func create(source: Node2D, victim: Node2D, amount: float, force: float = 0, posture: float = 0, id: String = "legacy") -> CombatHit:
	var hit := CombatHit.new()
	hit.attacker = source
	hit.target = victim
	hit.origin = source.global_position if is_instance_valid(source) else Vector2.ZERO
	hit.direction = hit.origin.direction_to(victim.global_position) if is_instance_valid(victim) else Vector2.ZERO
	hit.damage = amount
	hit.knockback = force
	hit.stagger = posture
	hit.attack_id = id
	return hit

func valid() -> bool:
	return is_instance_valid(target) and is_finite(damage) and damage >= 0 and is_finite(knockback) and knockback >= 0 and is_finite(stagger) and stagger >= 0 and origin.is_finite() and direction.is_finite() and not attack_id.is_empty()

func apply() -> bool:
	if not valid() or target.is_queued_for_deletion(): return false
	if not CombatFactions.hostile(attacker, target): return false
	if not target.has_method("receive_combat_hit"): return false
	return target.receive_combat_hit(self)
