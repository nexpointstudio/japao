class_name HurtboxComponent
extends Area2D

var actor: CharacterBody2D

func setup(who: CharacterBody2D, faction: int, size: Vector2) -> void:
	actor = who
	collision_layer = faction
	collision_mask = 0
	monitoring = false
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collider.shape = shape
	collider.position.y = -9
	add_child(collider)
