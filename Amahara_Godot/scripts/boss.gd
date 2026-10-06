class_name GeneralJinzo
extends CharacterBody2D

signal died
signal phase_changed(phase: int)
var game
var combat_target: Node2D
var hp: float = 480
var max_hp: float = 480
var posture: float = 100
var dead := false
var phase: int = 1
var transitions: int = 0
var state := "dormant"
var timer: float = 1
var elapsed: float = 0
var invuln: float = 0
var facing := Vector2.LEFT
var sprite: Sprite2D
var hurtbox: HurtboxComponent
var hitbox: HitboxComponent
var poses: Array[Texture2D] = []
var patterns: Dictionary = {}
var pattern: BossAttackData
var attack: AttackData
var cycle: int = 0
var combo_step: int = 0
var summons: Array = []
var performed: Array[String] = []

func _ready() -> void:
	game.targets.register(self, CombatFactions.Team.ENEMY)
	collision_layer = 16
	collision_mask = 1
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	var body := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 14
	body.shape = shape
	body.position.y = -6
	add_child(body)
	sprite = Sprite2D.new()
	for i in 8: poses.append(Catalog.frame(load("res://assets/jinzo_atlas.png"),i%4,i/4,4,2))
	sprite.texture = poses[0]
	sprite.scale = Vector2.ONE*(91.0/sprite.texture.get_width())
	sprite.position.y = -38
	add_child(sprite)
	hurtbox = HurtboxComponent.new()
	hurtbox.setup(self,8,Vector2(34,53))
	add_child(hurtbox)
	hitbox = HitboxComponent.new()
	hitbox.setup(self,4)
	add_child(hitbox)
	attack = load("res://data/enemy_slash.tres").duplicate()
	for id in ["combo","charge","wide","spirit","radial","summon"]:
		patterns[id] = load("res://data/boss_"+id+".tres")

func awaken() -> void:
	state = "chase"
	timer = 1.1

func _physics_process(dt: float) -> void:
	queue_redraw()
	invuln = maxf(0,invuln-dt)
	combat_target = game.targets.nearest(self)
	if dead or state == "dormant" or not is_instance_valid(combat_target) or game.hitstop > 0: return
	timer -= dt
	if phase == 1 and hp <= max_hp*.5:
		phase = 2
		transitions += 1
		state = "transition"
		timer = 1.8
		hitbox.finish()
		sprite.texture = poses[5]
		game.fx.ring(position,100,Color("b79bc8"),1.8)
		game.toast("Jinzō ergue o estandarte. O chamado ganha força.")
		phase_changed.emit(phase)
		return
	match state:
		"transition":
			if timer <= 0: begin_pattern("summon")
		"stagger":
			if timer <= 0:
				state = "recover"
				timer = .6
		"chase":
			facing = position.direction_to(combat_target.position)
			if position.distance_to(combat_target.position) > 48:
				velocity = facing*(49 if phase == 1 else 58)
				move_and_slide()
			if timer <= 0:
				var order := ["combo","charge","wide","spirit"] if phase == 1 else ["charge","radial","combo","wide","spirit","summon"]
				begin_pattern(order[cycle%order.size()])
				cycle += 1
		"telegraph":
			if timer <= 0: activate()
		"attack":
			elapsed += dt
			if pattern.id == "charge":
				velocity = facing*pattern.speed
				move_and_slide()
			if pattern.id == "combo" and elapsed > (combo_step+1)*.22 and combo_step < 2:
				combo_step += 1
				facing = position.direction_to(combat_target.position)
				hitbox.begin(attack,facing)
				game.fx.slash(position,facing,combo_step == 2,combo_step == 1)
				sprite.texture = poses[2 if combo_step < 2 else 4]
			hitbox.sample()
			if timer <= 0:
				hitbox.finish()
				state = "recover"
				timer = pattern.recovery
		"recover":
			sprite.texture = poses[0]
			if timer <= 0:
				state = "chase"
				timer = .5
	sprite.flip_h = facing.x > 0
	sprite.modulate = Color("fff1ce") if invuln > 0 else Color.WHITE

func begin_pattern(id: String) -> void:
	combat_target = game.targets.nearest(self)
	if not is_instance_valid(combat_target): return
	pattern = patterns[id]
	performed.append(id)
	state = "telegraph"
	timer = pattern.windup
	facing = position.direction_to(combat_target.position)
	sprite.texture = poses[pattern.pose]
	game.audio.sfx("warn")
	if id == "spirit":
		game.hazard(self,combat_target.position,42,pattern.damage,pattern.windup+.3)
		if phase == 2:
			game.hazard(self,combat_target.position+Vector2(55,0),34,pattern.damage,pattern.windup+.55)

func activate() -> void:
	state = "attack"
	timer = pattern.active
	elapsed = 0
	combo_step = 0
	attack.damage = pattern.damage
	attack.size = Vector2(52,48)
	attack.reach = 30
	match pattern.id:
		"combo","charge":
			hitbox.begin(attack,facing)
			sprite.texture = poses[2 if pattern.id == "combo" else 3]
			game.fx.slash(position,facing,true)
		"wide":
			game.hazard(self,position,pattern.radius,pattern.damage,0)
			game.fx.ring(position,pattern.radius,Color("dfbc83"),.3)
		"radial":
			for i in 12:
				var angle := i*TAU/12+.13
				game.hostile_shot(self,position+Vector2(0,-12),Vector2.from_angle(angle),pattern.damage)
		"summon":
			summons = summons.filter(func(e): return is_instance_valid(e) and not e.dead)
			for i in maxi(0,2-summons.size()):
				var at := Vector2(2730+i*140,580)
				summons.append(game.spawn_enemy(at,"swordsman"))
	game.audio.sfx("heavy")

func receive_hit(amount: float, source: Node2D, force: float, posture_damage: float) -> bool:
	return receive_combat_hit(CombatHit.create(source,self,amount,force,posture_damage))

func receive_combat_hit(hit: CombatHit) -> bool:
	if not hit.valid() or hit.target != self: return false
	var amount := hit.damage
	var posture_damage := hit.stagger
	if dead or invuln > 0 or state in ["dormant","transition"]: return false
	hp = maxf(0,hp-amount)
	invuln = .07
	posture -= posture_damage
	if hp <= 0:
		dead = true
		state = "dead"
		hitbox.finish()
		sprite.texture = poses[7]
		for enemy in summons:
			if is_instance_valid(enemy):
				enemy.dead = true
				enemy.queue_free()
		summons.clear()
		died.emit()
	elif posture <= 0:
		posture = 100
		hitbox.finish()
		state = "stagger"
		timer = 1.35
		game.fx.word(position,"JURAMENTO QUEBRADO",Color("ebce8c"))
	return true

func confirm_hit(_target: Node2D, _data: AttackData) -> void:
	game.camera_bump(4)

func _draw() -> void:
	draw_circle(Vector2.ZERO,18,Color(0,0,0,.25))
	if state != "telegraph" or not pattern: return
	var ink := Color("ecc08c")
	if pattern.id == "wide": draw_arc(Vector2.ZERO,pattern.radius,0,TAU,64,ink,2)
	elif pattern.id == "charge":
		draw_line(facing*20,facing*135,ink,2)
		draw_line(facing*135,facing*115+facing.orthogonal()*12,ink,2)
	else: draw_arc(Vector2.ZERO,40,facing.angle()-1,facing.angle()+1,20,ink,2)
