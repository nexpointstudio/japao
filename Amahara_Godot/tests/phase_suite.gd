extends Node

var checks: Array[Dictionary] = []
var game

func check(id: String, result: bool, detail: String = "") -> void:
	checks.append({"id":id,"result":"PASS" if result else "FAIL","detail":detail})
	print(("PASS " if result else "FAIL ")+id+ (" / "+detail if detail else ""))

func ticks(count: int) -> void:
	for i in count:
		await get_tree().physics_frame

func seconds(duration: float) -> void:
	await get_tree().create_timer(duration).timeout

func tap(action: String) -> void:
	Input.action_press(action)
	await ticks(2)
	Input.action_release(action)
	await ticks(1)

func settle_player() -> void:
	game.player.restore(Vector2(512,416))
	game.player.invuln = 0
	game.hitstop = 0
	await ticks(3)

func stop_move() -> void:
	for action in ["move_left","move_right","move_up","move_down"]:
		Input.action_release(action)

func navigate(target: Vector2, timeout: float = 14) -> bool:
	var elapsed := 0.0
	var path: PackedVector2Array = game.world.route(game.player.position,target)
	if path.is_empty(): return false
	var node := 0
	while elapsed < timeout:
		if node >= path.size():
			stop_move()
			return true
		var delta: Vector2 = path[node]-game.player.position
		if delta.length() < 6:
			node += 1
			continue
		stop_move()
		if absf(delta.x) > 3: Input.action_press("move_right" if delta.x > 0 else "move_left")
		if absf(delta.y) > 3: Input.action_press("move_down" if delta.y > 0 else "move_up")
		await ticks(1)
		elapsed += 1.0/60.0
	stop_move()
	return false

func combo(first: String, branch: String) -> Array[String]:
	game.player.attacks_performed.clear()
	game.player.start_attack(first)
	for i in 200:
		if game.player.state != "attack": break
		var a: AttackData = game.player.current_attack
		if game.player.attack_elapsed > a.duration()-.15:
			game.player.buffer_attack(branch)
		await ticks(1)
	return game.player.attacks_performed.duplicate()

func run(host) -> void:
	game = host
	check("menu_initial",game.ui.menu.visible and game.get_tree().paused)
	check("viewport_640_360",get_viewport().get_visible_rect().size == Vector2(640,360))
	check("native_tilemap",game.world.ground is TileMapLayer)
	check("resources_loaded",game.player.attacks.size() == 7)
	var all_inputs := true
	for action in ["move_left","move_right","move_up","move_down","attack_light","attack_heavy","dash","magic_1","magic_2","interact","pause"]:
		var events := InputMap.action_get_events(action)
		var has_key := false
		var has_pad := false
		for event in events:
			has_key = has_key or event is InputEventKey
			has_pad = has_pad or event is InputEventJoypadButton or event is InputEventJoypadMotion
		all_inputs = all_inputs and has_key and has_pad
	check("input_map_keyboard_gamepad",all_inputs)
	game.start_sample()
	check("intro_open",game.ui.dialog.visible)
	var initial: Vector2 = game.player.position
	Input.action_press("move_right")
	await seconds(.1)
	Input.action_release("move_right")
	check("dialogue_freezes_player",game.player.position == initial)
	while game.ui.dialog.visible: game.next_dialogue()
	await ticks(3)
	Input.action_press("move_right")
	await seconds(.3)
	Input.action_release("move_right")
	check("movement",game.player.position.x > initial.x+20)
	check("facing",game.player.facing == Vector2.RIGHT)
	Input.action_press("move_up")
	Input.action_press("move_right")
	check("diagonal_normalized",absf(InputConfig.movement().length()-1) < .001)
	stop_move()
	await settle_player()
	game.player.position = Vector2(880,320)
	Input.action_press("move_right")
	await seconds(.35)
	Input.action_release("move_right")
	check("water_collision",game.player.position.x < 890)
	game.player.state = "idle"
	game.player.dash_cd = 0
	game.player.start_dash(Vector2.RIGHT)
	await seconds(.23)
	check("dash_wall_collision",game.player.position.x < 890)
	await settle_player()
	var light := await combo("light_1","light")
	check("light_three_hits",light == ["light_1","light_2","light_3"],str(light))
	await settle_player()
	var heavy := await combo("heavy_1","heavy")
	check("heavy_three_hits",heavy == ["heavy_1","heavy_2","heavy_3"],str(heavy))
	await settle_player()
	game.player.start_attack("light_2")
	await seconds(.23)
	game.player.buffer_attack("heavy")
	await seconds(.26)
	check("branch_to_heavy_finisher",game.player.current_attack != null and game.player.current_attack.id == "heavy_3")
	await settle_player()
	game.player.start_attack("heavy_1")
	game.player.buffer_attack("heavy")
	await seconds(.65)
	check("expired_buffer_rejected",game.player.state != "attack")
	await settle_player()
	var enemy: VillageEnemy = game.enemies[0]
	enemy.set_physics_process(false)
	enemy.position = Vector2(546,416)
	enemy.invuln = 0
	game.player.facing = Vector2.RIGHT
	game.player.energy = 40
	game.player.start_attack("light_1")
	await seconds(.24)
	check("real_area_hitbox_damage",enemy.hp == 37,"HP="+str(enemy.hp))
	check("confirmed_hit_energy",game.player.energy > 46)
	var hp_before := enemy.hp
	game.player.hitbox.sample()
	check("single_hit_protection",enemy.hp == hp_before)
	await settle_player()
	enemy.position = Vector2(546,416)
	enemy.invuln = 1
	game.player.facing = Vector2.RIGHT
	game.player.energy = 40
	game.player.start_attack("light_1")
	await seconds(.24)
	check("no_energy_on_rejected_hit",game.player.energy < 42)
	enemy.invuln = 0
	await settle_player()
	game.player.start_dash(Vector2.RIGHT)
	var old_hp: float = game.player.hp
	game.player.energy = 40
	game.player.receive_hit(10,enemy,50,10)
	check("dash_iframes",game.player.hp == old_hp)
	check("perfect_dodge_reward",game.player.rewarded_dodge and game.player.energy == 52)
	game.player.receive_hit(10,enemy,50,10)
	check("perfect_dodge_once",game.player.energy == 52)
	await seconds(.23)
	check("dash_cooldown",not game.player.start_dash(Vector2.RIGHT))
	await settle_player()
	game.player.energy = 0
	check("magic_no_energy",not game.player.cast(0) and game.projectiles.get_child_count() == 0)
	game.player.energy = 100
	game.player.facing = Vector2.RIGHT
	game.player.position = Vector2(512,470)
	enemy.position = Vector2(600,470)
	enemy.hp = 58
	enemy.invuln = 0
	game.player.cast(0)
	check("magic_cost",game.player.energy == 75)
	await seconds(.6)
	check("projectile_actual_hit",enemy.hp == 34,"HP="+str(enemy.hp))
	await settle_player()
	enemy.hp = 58
	enemy.position = Vector2(545,416)
	enemy.posture = 32
	enemy.invuln = 0
	game.player.cast(1)
	check("seal_damage_stagger",enemy.hp == 40 and enemy.state == "stagger")
	check("seal_cost",game.player.energy == 65)
	await settle_player()
	game.player.receive_hit(10,enemy,0,0)
	check("hurt_state",game.player.state == "hurt" and game.player.hp == 90)
	game.player.receive_hit(10,enemy,0,0)
	check("post_hit_iframes",game.player.hp == 90)
	game.player.invuln = 0
	game.player.receive_hit(999,enemy,0,0)
	check("death_state",game.player.dead)
	check("cannot_attack_dead",not game.player.start_attack("light_1") and not game.player.cast(1))
	await seconds(1.25)
	check("respawn_full_health",not game.player.dead and game.player.hp == 100)
	check("respawn_group_reset",game.enemies.size() == 2 and game.world.actors.get_children().filter(func(n): return n is VillageEnemy).size() == 2)
	game.set_paused(true)
	game.ui.show_pause()
	check("pause_modal",get_tree().paused and is_instance_valid(game.ui.modal))
	game.ui.show_controls()
	check("controls_modal",is_instance_valid(game.ui.modal))
	game.ui.clear_modal()
	game.set_paused(false)
	# Isolated fixtures below use explicit positions/state; not the playthrough.
	game.director.active = {"village":[],"forest":[],"bridge":[],"corruption":[],"elite":[]}
	for e in game.enemies:
		if is_instance_valid(e): e.queue_free()
	game.enemies.clear()
	await ticks(3)
	for kind in ["swordsman","runner","heavy","archer","seal"]:
		await settle_player()
		var e: VillageEnemy = game.spawn_enemy(Vector2(550,416),kind)
		await ticks(3)
		check(kind+"_resource",e.hp == e.data.hp and e.poses.size() == 4)
		e.state = "chase"
		await seconds(.12)
		check(kind+"_telegraph",e.state == "telegraph")
		await seconds(e.timer+.04)
		check(kind+"_attack",e.state == "attack")
		await seconds(.38)
		check(kind+"_recovery",e.state == "recover")
		e.invuln = 0
		e.receive_hit(1,game.player,0,1)
		check(kind+"_resistance",e.state != "hurt" if kind == "heavy" else e.state == "hurt")
		e.invuln = 0
		e.receive_hit(1,game.player,0,100)
		check(kind+"_stagger",e.state == "stagger")
		e.invuln = 0
		e.receive_hit(999,game.player,0,1)
		check(kind+"_death_releases_token",e.dead and e not in game.director.tokens and not e.hitbox.enabled)
		await seconds(.8)
		check(kind+"_cleanup",not is_instance_valid(e))
	game.enemies.clear()
	game.clear_effects()
	for group in [["swordsman","swordsman"],["swordsman","runner"],["swordsman","archer"],["heavy","archer"],["heavy","runner","archer","seal"]]:
		await settle_player()
		var cohort: Array = []
		for i in group.size(): cohort.append(game.spawn_enemy(Vector2(550+i*4,416+i*5),group[i]))
		await seconds(.4)
		check("group_slots_"+str(group),game.director.tokens.size() <= 2)
		for e in cohort:
			e.invuln = 0
			e.receive_hit(999,game.player,0,100)
		await seconds(.85)
		check("group_cleanup_"+str(group),game.director.tokens.is_empty())
	game.enemies.clear()
	game.clear_effects()
	game.player.restore(Vector2(2700,440))
	game.boss.position = Vector2(2790,440)
	game.boss.state = "chase"
	game.boss.set_physics_process(false)
	for id in game.boss.patterns:
		game.player.restore(Vector2(2700,440))
		game.boss.position = Vector2(2790,440)
		game.boss.set_physics_process(true)
		game.boss.begin_pattern(id)
		check("boss_telegraph_"+id,game.boss.state == "telegraph" and not game.boss.hitbox.enabled)
		await seconds(game.boss.pattern.windup+.08)
		check("boss_active_"+id,game.boss.state == "attack")
		await seconds(game.boss.pattern.active+.07)
		check("boss_recovery_"+id,game.boss.state == "recover")
		game.boss.set_physics_process(false)
		game.clear_effects()
	check("boss_summon_limit",game.boss.summons.size() == 2)
	game.boss.activate()
	check("boss_summon_limit_repeat",game.boss.summons.size() == 2)
	game.boss.hp = 240
	game.boss.set_physics_process(true)
	await ticks(3)
	check("boss_half_transition",game.boss.phase == 2 and game.boss.transitions == 1)
	await seconds(2.0)
	check("boss_transition_unique",game.boss.transitions == 1)
	game.story.restore({"stage":5,"checkpoint":"sanctuary","completed":["village","elite"],"upgrades":["altar"],"shortcut":true})
	game.apply_upgrades()
	game.respawn()
	await ticks(4)
	check("boss_reset_health_phase",game.boss.hp == 480 and game.boss.phase == 1 and game.boss.state == "dormant" and game.boss.summons.is_empty())
	check("boss_reset_projectiles_gate",game.projectiles.get_child_count() == 0 and not game.world.gate_closed.arena)
	check("checkpoint_restore_stats",game.player.position.distance_to(Vector2(2208,424)) < 2 and game.player.max_energy == 125)
	game.player.position = Vector2(1712,675)
	await ticks(3)
	game.interact()
	while game.ui.dialog.visible: game.next_dialogue()
	check("upgrade_not_duplicated",game.player.max_energy == 125 and game.story.upgrades.size() == 1)
	check("save_write_v2",game.save_progress())
	var saved := SaveStore.read_save()
	check("save_read_fields",saved.get("checkpoint","") == "sanctuary" and saved.get("shortcut",false) and "altar" in saved.get("upgrades",[]))
	game.save_progress()
	var broken := FileAccess.open(SaveStore.path(),FileAccess.WRITE)
	broken.store_string("{not valid")
	broken.close()
	check("save_backup_recovery",not SaveStore.read_save().is_empty() and SaveStore.recovered_backup)
	check("invalid_content_rejected",not SaveStore.validate({"version":2,"stage":99,"checkpoint":"village","upgrades":[],"completed":[],"shortcut":false}))
	game.save_progress()
	game.return_menu()
	game.start_sample(true)
	while game.ui.dialog.visible: game.next_dialogue()
	check("continue_roundtrip",game.story.stage == 5 and game.player.max_energy == 125 and game.story.shortcut)
	game.player.invuln = 0
	game.player.receive_hit(999,game.boss,0,0)
	game.return_menu()
	await seconds(1.3)
	check("menu_cancels_death_timer",not game.running and game.ui.menu.visible and get_tree().paused)
	game.start_sample()
	while game.ui.dialog.visible: game.next_dialogue()
	check("new_game_clears_upgrades",game.story.stage == 0 and game.player.max_energy == 100 and game.world.gate_closed.arena and game.world.gate_closed.village)
	game.ui.show_options()
	check("options_focus",get_viewport().gui_get_focus_owner() is HSlider)
	game.ui.clear_modal()
	check("checkpoint_route",not game.world.route(Vector2(1250,416),Vector2(2208,424)).is_empty())
	game.world.set_gate("shortcut",false)
	check("shortcut_route",not game.world.route(Vector2(1790,576),Vector2(1930,576)).is_empty())
	var failures := checks.filter(func(c): return c.result == "FAIL").size()
	DirAccess.make_dir_recursive_absolute(game.evidence_dir)
	var report := {"type":"isolated_fixtures","pass":checks.size()-failures,"fail":failures,"checks":checks,"controllers":Input.get_connected_joypads(),"physical_dualsense":"NOT_TESTED"}
	var f := FileAccess.open(game.evidence_dir+"/phase_qa.json",FileAccess.WRITE)
	f.store_string(JSON.stringify(report,"\t"))
	f.close()
	print("PHASE_QA ",checks.size()-failures," PASS / ",failures," FAIL")
	await game.close_game(1 if failures else 0)
