class_name HostileEffect
extends Area2D

var game
var source: Node2D
var direction := Vector2.ZERO
var speed: float = 180
var radius: float = 36
var damage: float = 13
var delay: float = .85
var life: float = .35
var age: float = 0
var fired := false
var struck := false
var projectile := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 4 | 8 | (1 if projectile else 0)
	var c := CollisionShape2D.new()
	var s := CircleShape2D.new()
	s.radius = 5 if projectile else radius
	c.shape = s
	add_child(c)
	if projectile:
		delay = 0
		life = 2.4
		body_entered.connect(func(_b): queue_free())
	z_index = 3

func _physics_process(dt: float) -> void:
	if not is_instance_valid(source) or source.dead or game.targets.hostiles(source).is_empty():
		queue_free()
		return
	age += dt
	if projectile: position += direction*speed*dt
	if age >= delay:
		if not fired:
			fired = true
			if not projectile: game.audio.sfx("magic2")
		if not struck:
			for area in get_overlapping_areas():
				if area is HurtboxComponent and CombatFactions.hostile(source,area.actor):
					var hit := CombatHit.create(source,area.actor,damage,60,0,"hazard:%d" % get_instance_id())
					hit.source_kind = &"projectile" if projectile else &"hazard"
					hit.apply()
					struck = true
	if age >= delay+life or (projectile and struck): queue_free()
	queue_redraw()

func _draw() -> void:
	if projectile:
		draw_line(-direction*12,direction*5,Color("d1a6dd"),2)
		draw_circle(direction*5,3,Color("edcfaa"))
	else:
		draw_circle(Vector2.ZERO,radius,Color(.30,.16,.38,.20 if not fired else .38))
		draw_arc(Vector2.ZERO,radius,0,TAU,48,Color("b898c4") if not fired else Color("ead7af"),2)
		if not fired:
			draw_arc(Vector2.ZERO,radius-4,-PI/2,-PI/2+TAU*minf(1,age/delay),40,Color("dabc8b"),2)
