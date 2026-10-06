class_name VillageEnemy
extends CharacterBody2D

signal died
signal staggered
var game
var kind := "swordsman"
var data: EnemyData
var hp: float
var max_hp: float
var posture: float
var dead := false
var state := "idle"
var timer: float = .5
var invuln: float = 0
var facing := Vector2.LEFT
var attack: AttackData
var sprite: Sprite2D
var hitbox: HitboxComponent
var hurtbox: HurtboxComponent
var home := Vector2.ZERO
var route := PackedVector2Array()
var path_timer: float = 0
var knock := Vector2.ZERO
var clock: float = 0
var target_point := Vector2.ZERO
var combat_target: Node2D
var poses: Array[Texture2D] = []

func _ready() -> void:
	game.targets.register(self, CombatFactions.Team.ENEMY)
	data = load("res://data/enemy_"+kind+".tres")
	hp = data.hp
	max_hp = hp
	posture = data.posture
	home = position
	collision_layer = 16
	collision_mask = 1
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	var body := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 8
	shape.height = 18
	body.shape = shape
	body.position.y = -4
	add_child(body)
	sprite = Sprite2D.new()
	if kind == "swordsman":
		poses = [Catalog.prop_texture(14),Catalog.prop_texture(14),Catalog.prop_texture(15),Catalog.prop_texture(15)]
	else:
		var row := ["runner","heavy","archer","seal"].find(kind)
		for col in 4: poses.append(Catalog.frame(load("res://assets/enemies_atlas.png"),col,row,4,4))
	sprite.texture = poses[0]
	sprite.scale = Vector2.ONE * ((59.0 if kind == "heavy" else 53.0) / sprite.texture.get_width())
	sprite.position.y = -23
	add_child(sprite)
	hurtbox = HurtboxComponent.new()
	hurtbox.setup(self,8,Vector2(20,28))
	add_child(hurtbox)
	hitbox = HitboxComponent.new()
	hitbox.setup(self,4)
	add_child(hitbox)
	attack = load("res://data/enemy_slash.tres").duplicate()
	attack.damage = data.damage
	attack.startup = data.windup
	attack.recovery = data.recovery
	if kind == "heavy":
		attack.size = Vector2(54,48)
		attack.reach = 34
	if kind == "runner": attack.active = .3

func _physics_process(dt: float) -> void:
	clock += dt
	invuln = maxf(0,invuln-dt)
	queue_redraw()
	if dead or game.hitstop > 0: return
	combat_target = game.targets.nearest(self)
	if not is_instance_valid(combat_target):
		cancel_attack()
		state = "idle"
		return
	timer -= dt
	path_timer -= dt
	sprite.modulate = Color("fff1ce") if invuln > 0 else Color.WHITE
	if state in ["hurt","stagger"]:
		velocity = knock
		knock = knock.move_toward(Vector2.ZERO,300*dt)
		move_and_slide()
		if timer <= 0:
			state = "recover"
			timer = .3
		return
	var distance := global_position.distance_to(combat_target.global_position)
	match state:
		"idle":
			if distance < data.detection: state = "chase"
		"chase":
			if distance > 360:
				state = "return"
			elif distance < data.preferred_distance and line_of_sight() and game.director.request(self):
				state = "telegraph"
				timer = data.windup
				facing = global_position.direction_to(combat_target.global_position)
				target_point = combat_target.position
				game.audio.sfx("warn")
			elif kind in ["archer","seal"] and distance < 100:
				walk_towards(position-position.direction_to(combat_target.position)*60,data.speed,dt)
			else:
				var target: Vector2 = combat_target.position
				if kind == "runner" and distance > 95: target += Vector2(0,48 if get_instance_id()%2 == 0 else -48)
				walk_towards(target,data.speed,dt)
		"return":
			walk_towards(home,data.speed,dt)
			if global_position.distance_to(home) < 12: state = "idle"
		"telegraph":
			if timer <= 0:
				state = "attack"
				timer = attack.active
				if kind == "archer": game.hostile_shot(self,global_position+Vector2(0,-10),facing,data.damage)
				elif kind == "seal": game.hazard(self,target_point,38,data.damage,.85)
				else:
					hitbox.begin(attack,facing)
					game.fx.slash(global_position,facing,kind == "heavy")
		"attack":
			if kind == "runner":
				velocity = facing*190
				move_and_slide()
			hitbox.sample()
			if timer <= 0:
				cancel_attack()
				state = "recover"
				timer = data.recovery
		"recover":
			if distance < 32 and kind == "swordsman":
				velocity = -position.direction_to(combat_target.position)*22
				move_and_slide()
			if timer <= 0: state = "chase"
	sprite.texture = poses[2 if state == "telegraph" else 3 if state == "attack" else 1 if state in ["chase","return"] and int(clock*7)%2 else 0]
	sprite.flip_h = facing.x < -.2
	sprite.position.y = -23 + (round(sin(clock*10)) if state == "chase" else 0)

func line_of_sight() -> bool:
	combat_target = game.targets.nearest(self)
	if not is_instance_valid(combat_target): return false
	var query := PhysicsRayQueryParameters2D.create(position+Vector2(0,-8),combat_target.position+Vector2(0,-8),1)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func cancel_attack() -> void:
	hitbox.finish()
	game.director.release(self)

func walk_towards(target: Vector2, speed: float, _dt: float) -> void:
	if path_timer <= 0:
		path_timer = .3
		route = game.world.route(global_position,target)
	var waypoint := target
	while route.size() > 0 and global_position.distance_to(route[0]) < 9: route.remove_at(0)
	if route.size() > 0: waypoint = route[0]
	facing = global_position.direction_to(waypoint)
	var separation := Vector2.ZERO
	for other in game.enemies:
		if not is_instance_valid(other) or other == self or other.dead: continue
		var delta: Vector2 = position-other.position
		if delta.length() < 24 and delta.length() > .1: separation += delta.normalized()*(24-delta.length())*2
	velocity = facing*speed+separation
	move_and_slide()

func receive_hit(amount: float, source: Node2D, force: float, posture_damage: float) -> bool:
	return receive_combat_hit(CombatHit.create(source,self,amount,force,posture_damage))

func receive_combat_hit(hit: CombatHit) -> bool:
	if not hit.valid() or hit.target != self: return false
	var amount := hit.damage
	var force := hit.knockback
	var posture_damage := hit.stagger
	if dead or invuln > 0: return false
	hp = maxf(0,hp-amount)
	posture -= posture_damage
	invuln = .08
	knock = hit.direction*force
	if hp <= 0:
		cancel_attack()
		dead = true
		state = "dead"
		game.fx.burst(global_position+Vector2(0,-18),Color("9e729f"),24)
		sprite.modulate = Color(.55,.48,.55,.7)
		sprite.rotation = .8
		died.emit()
		var tween := create_tween()
		tween.tween_property(sprite,"modulate:a",0.0,.7)
		tween.tween_callback(queue_free)
	elif posture <= 0:
		cancel_attack()
		state = "stagger"
		timer = 1.15
		posture = data.posture
		game.fx.word(global_position,"POSTURA QUEBRADA",Color("ebce8c"))
		staggered.emit()
	elif kind != "heavy" and state != "stagger":
		cancel_attack()
		state = "hurt"
		timer = .16
	return true

func confirm_hit(_target: Node2D, _data: AttackData) -> void:
	game.hitstop = .04

func _draw() -> void:
	if dead or not data: return
	draw_circle(Vector2(0,-1),9,Color(0,0,0,.2))
	if hp < max_hp or state != "idle":
		draw_rect(Rect2(-16,-55,32,3),Color("17241f"))
		draw_rect(Rect2(-16,-55,32*hp/max_hp,3),Color("b46958"))
		draw_rect(Rect2(-16,-50,32*(1-posture/data.posture),2),Color("d1b671"))
	if state == "telegraph":
		draw_arc(Vector2.ZERO,27,facing.angle()-.8,facing.angle()+.8,18,Color("efb773"),2)
		draw_string(ThemeDB.fallback_font,Vector2(-3,-60),"!",HORIZONTAL_ALIGNMENT_LEFT,-1,15,Color("f8cf8b"))
