class_name WorldInteraction
extends Area2D

var info: Dictionary

func _ready() -> void:
	collision_layer = 0
	collision_mask = 4
	var collider := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 44
	collider.shape = shape
	add_child(collider)

func available() -> bool:
	return not get_overlapping_areas().is_empty()
