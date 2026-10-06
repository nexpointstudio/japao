class_name CelestialSlash
extends Area2D

var game
var direction := Vector2.RIGHT
var lifetime: float = 1.35
var spent := false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 8|1
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(14,30)
	collider.shape = shape
	add_child(collider)
	rotation = direction.angle()
	area_entered.connect(_hit)
	body_entered.connect(func(_body): retire())

func _physics_process(dt: float) -> void:
	if spent: return
	position += direction*game.player.magics[0].speed*dt
	lifetime -= dt
	if lifetime <= 0:
		retire()
	if Engine.get_physics_frames()%3 == 0:
		game.fx.burst(global_position,Color("7edbc4"),1,10)
	queue_redraw()

func _hit(area: Area2D) -> void:
	if spent: return
	if area is HurtboxComponent:
		if area.actor.receive_hit(game.player.magics[0].damage,game.player,70,game.player.magics[0].stagger):
			game.fx.burst(global_position,Color("baefd6"),15)
			game.fx.word(area.actor.global_position,"24",Color("baefd6"))
			game.audio.sfx("hit")
		retire()

func retire() -> void:
	spent = true
	queue_free()

func _draw() -> void:
	draw_arc(Vector2(-7,0),18,-.95,.95,12,Color("e7efd5"),3)
	draw_arc(Vector2(-12,0),19,-1,1,12,Color("65bfae"),2)
