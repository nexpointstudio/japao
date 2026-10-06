class_name RenPlayer
extends CharacterBody2D

signal health_changed(current: float, maximum: float)
signal energy_changed(current: float, maximum: float)
signal died
signal perfect_dodge

const SPEED := 108.0
const DASH_SPEED := 330.0
const DASH_TIME := .18
const DASH_COOLDOWN := .62
var game
var hp: float = 100
var max_hp: float = 100
var energy: float = 100
var max_energy: float = 100
var state: String = "idle"
var dead: bool = false
var facing := Vector2.DOWN
var invuln: float = 0
var timer: float = 0
var dash_cd: float = 0
var dash_elapsed: float = 0
var dash_dir := Vector2.RIGHT
var rewarded_dodge := false
var cast_cd: Array[float] = [0.0,0.0]
var current_attack: AttackData
var attack_elapsed: float = 0
var attack_phase: String = ""
var combo_buffer: String = ""
var buffer_expiry: float = 0
var hitbox: HitboxComponent
var hurtbox: HurtboxComponent
var sprite: AnimatedSprite2D
var attacks: Dictionary
var magics: Array[MagicData] = []
var knock := Vector2.ZERO
var attacks_performed: Array[String] = []

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	var body := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 7
	shape.height = 16
	body.shape = shape
	body.position.y = -4
	add_child(body)
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = Catalog.player_frames()
	var cell_size := sprite.sprite_frames.get_frame_texture("idle_down",0).get_width()
	sprite.scale = Vector2.ONE * (48.0 / cell_size)
	sprite.position.y = -20
	add_child(sprite)
	hurtbox = HurtboxComponent.new()
	hurtbox.setup(self, 4, Vector2(16,26))
	add_child(hurtbox)
	hitbox = HitboxComponent.new()
	hitbox.setup(self,8)
	add_child(hitbox)
	attacks = Catalog.attacks()
	magics = [load("res://data/celestial.tres"),load("res://data/rupture.tres")]
	play_pose("idle")

func _physics_process(dt: float) -> void:
	invuln = maxf(0,invuln-dt)
	dash_cd = maxf(0,dash_cd-dt)
	for i in 2:
		cast_cd[i] = maxf(0,cast_cd[i]-dt)
	if not dead:
		energy = minf(max_energy, energy + 2.2*dt)
	sprite.modulate.a = .6 if invuln > 0 and int(invuln*24)%2 == 0 else 1.0
	if dead:
		return
	if game.hitstop > 0:
		return
	if state == "hurt":
		timer -= dt
		velocity = knock
		knock = knock.move_toward(Vector2.ZERO,550*dt)
		move_and_slide()
		if timer <= 0:
			state = "idle"
	elif state == "dash":
		timer -= dt
		dash_elapsed += dt
		velocity = dash_dir*DASH_SPEED
		move_and_slide()
		if Engine.get_physics_frames()%3 == 0:
			game.fx.burst(global_position+Vector2(0,-8),Color("c7b776"),2,10)
		if timer <= 0:
			state = "idle"
	elif state == "attack":
		update_attack(dt)
	elif state == "cast":
		timer -= dt
		if timer <= 0:
			state = "idle"
	else:
		var direction := InputConfig.movement()
		velocity = direction*SPEED
		if direction.length() > .1:
			set_facing(direction)
			state = "move"
			play_pose("walk")
		else:
			state = "idle"
			play_pose("idle")
		move_and_slide()
		if Input.is_action_just_pressed("dash"):
			start_dash(direction)
		elif Input.is_action_just_pressed("attack_light"):
			start_attack("light_1")
		elif Input.is_action_just_pressed("attack_heavy"):
			start_attack("heavy_1")
		elif Input.is_action_just_pressed("magic_1"):
			cast(0)
		elif Input.is_action_just_pressed("magic_2"):
			cast(1)
	queue_redraw()

func set_facing(direction: Vector2) -> void:
	if absf(direction.x) > absf(direction.y):
		facing = Vector2(signf(direction.x),0)
	else:
		facing = Vector2(0,signf(direction.y))

func direction_name() -> String:
	if facing.x > 0: return "right"
	if facing.x < 0: return "left"
	if facing.y < 0: return "up"
	return "down"

func play_pose(pose: String) -> void:
	sprite.play(pose + "_" + direction_name())
	sprite.scale = Vector2.ONE*(48.0/sprite.sprite_frames.get_frame_texture(sprite.animation,0).get_width())

func start_attack(id: String) -> bool:
	if dead or state in ["hurt","dash","cast"] or not attacks.has(id):
		return false
	current_attack = attacks[id]
	attacks_performed.append(id)
	state = "attack"
	attack_elapsed = 0
	attack_phase = "startup"
	combo_buffer = ""
	hitbox.finish()
	play_pose("windup")
	return true

func update_attack(dt: float) -> void:
	attack_elapsed += dt
	var a := current_attack
	if Input.is_action_just_pressed("attack_light"):
		buffer_attack("light")
	if Input.is_action_just_pressed("attack_heavy"):
		buffer_attack("heavy")
	if attack_elapsed < a.startup:
		return
	if attack_elapsed < a.startup+a.active:
		if attack_phase != "active":
			attack_phase = "active"
			hitbox.begin(a,facing)
			play_pose(a.animation)
			game.fx.slash(global_position,facing,a.id.begins_with("heavy"),a.animation == "reverse")
			game.audio.sfx("heavy" if a.id.begins_with("heavy") else "slash")
		velocity = facing*a.step_speed
		move_and_slide()
		hitbox.sample()
	else:
		hitbox.finish()
		attack_phase = "recovery"
		if attack_elapsed >= a.duration():
			var next := a.next_light if combo_buffer == "light" else a.next_heavy if combo_buffer == "heavy" else ""
			if not next.is_empty() and attack_elapsed <= buffer_expiry:
				start_attack(next)
			else:
				state = "idle"
				current_attack = null

func buffer_attack(kind: String) -> void:
	if state != "attack": return
	combo_buffer = kind
	buffer_expiry = attack_elapsed + current_attack.buffer_window

func start_dash(direction: Vector2) -> bool:
	if dead or dash_cd > 0 or state in ["hurt","attack","cast","dash"]: return false
	dash_dir = direction.normalized() if direction.length() > .1 else facing
	set_facing(dash_dir)
	state = "dash"
	timer = DASH_TIME
	dash_elapsed = 0
	dash_cd = DASH_COOLDOWN
	invuln = DASH_TIME
	rewarded_dodge = false
	play_pose("dash")
	game.audio.sfx("dash")
	return true

func cast(slot: int) -> bool:
	var magic := magics[slot]
	var cost := magic.cost
	if dead or state in ["hurt","dash","attack","cast"]: return false
	if cast_cd[slot] > 0:
		game.toast("A técnica ainda está se recuperando.")
		return false
	if energy < cost:
		game.toast("Use a katana para recuperar Energia Divina.")
		return false
	energy -= cost
	energy_changed.emit(energy,max_energy)
	cast_cd[slot] = magic.cooldown
	state = "cast"
	timer = .24 if slot == 0 else .34
	play_pose("cast")
	if slot == 0:
		game.launch_slash(global_position+Vector2(0,-12)+facing*16,facing)
	else:
		game.fx.ring(global_position,62,Color("deb977"),.5)
		game.fx.burst(global_position,Color("deb977"),24)
		for enemy in game.combat_targets():
			if is_instance_valid(enemy) and not enemy.dead and global_position.distance_to(enemy.global_position) < magic.radius:
				enemy.receive_hit(magic.damage,self,95,magic.stagger)
	game.audio.sfx("magic1" if slot == 0 else "magic2")
	return true

func receive_hit(amount: float, source: Node2D, force: float, _posture_damage: float) -> bool:
	if dead: return false
	if invuln > 0:
		if state == "dash" and dash_elapsed <= .09 and not rewarded_dodge:
			rewarded_dodge = true
			energy = minf(max_energy,energy+12)
			perfect_dodge.emit()
			game.fx.word(global_position,"ESQUIVA PERFEITA",Color("b5eee0"))
			game.fx.ring(global_position,30,Color("b5eee0"),.22)
			game.audio.sfx("perfect")
		return false
	hp = maxf(0,hp-amount)
	invuln = .62
	hitbox.finish()
	combo_buffer = ""
	knock = source.global_position.direction_to(global_position)*force
	game.fx.burst(global_position+Vector2(0,-12),Color("d78b76"),12)
	game.audio.sfx("hurt")
	game.camera_bump(3)
	health_changed.emit(hp,max_hp)
	if hp <= 0:
		dead = true
		state = "dead"
		play_pose("death")
		died.emit()
	else:
		state = "hurt"
		timer = .22
		play_pose("hurt")
	return true

func confirm_hit(target: Node2D, a: AttackData) -> void:
	energy = minf(max_energy,energy+a.energy_gain)
	energy_changed.emit(energy,max_energy)
	game.hitstop = maxf(game.hitstop,a.hitstop)
	game.fx.burst(target.global_position+Vector2(0,-16),Color("efd298"),12)
	game.fx.word(target.global_position,str(int(a.damage)),Color("f5ddb0"))
	game.audio.sfx("hit")
	if a.id.begins_with("heavy"):
		game.camera_bump(2)
		game.rumble(.18,.1,.1)

func restore(at: Vector2) -> void:
	global_position = at
	hp = max_hp
	energy = max_energy
	dead = false
	state = "idle"
	current_attack = null
	hitbox.finish()
	combo_buffer = ""
	dash_cd = 0
	cast_cd = [0.0,0.0]
	invuln = .8
	knock = Vector2.ZERO
	velocity = Vector2.ZERO
	play_pose("idle")

func _draw() -> void:
	draw_ellipse_shadow()

func draw_ellipse_shadow() -> void:
	var points := PackedVector2Array()
	for i in 16:
		points.append(Vector2(cos(i*TAU/16)*10,sin(i*TAU/16)*4))
	draw_colored_polygon(points,Color(0.03,.04,.035,.45))
