class_name HitboxComponent
extends Area2D

var actor: CharacterBody2D
var attack: AttackData
var struck: Dictionary = {}
var enabled: bool = false
var collider: CollisionShape2D

func setup(who: CharacterBody2D, target_layer: int) -> void:
	actor = who
	collision_layer = 0
	collision_mask = target_layer
	monitorable = false
	collider = CollisionShape2D.new()
	collider.shape = RectangleShape2D.new()
	add_child(collider)

func begin(data: AttackData, direction: Vector2) -> void:
	attack = data
	struck.clear()
	position = direction * attack.reach + Vector2(0, -9)
	rotation = direction.angle()
	(collider.shape as RectangleShape2D).size = attack.size
	enabled = true

func sample() -> void:
	if not enabled or not is_instance_valid(actor) or actor.dead:
		return
	for area in get_overlapping_areas():
		if area is HurtboxComponent and not struck.has(area.actor.get_instance_id()):
			var target = area.actor
			struck[target.get_instance_id()] = true
			if target.receive_hit(attack.damage, actor, attack.knockback, attack.stagger):
				actor.confirm_hit(target, attack)

func finish() -> void:
	enabled = false
