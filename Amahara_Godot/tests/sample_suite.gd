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
	check("real_area_hitbox_damage",enemy.hp == 47,"HP="+str(enemy.hp))
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
	check("respawn_single_enemy",game.enemies.size() == 1 and game.world.actors.get_children().filter(func(n): return n is VillageEnemy).size() == 1)
	game.set_paused(true)
	game.ui.show_pause()
	check("pause_modal",get_tree().paused and is_instance_valid(game.ui.modal))
	game.ui.show_controls()
	check("controls_modal",is_instance_valid(game.ui.modal))
	game.ui.clear_modal()
	game.set_paused(false)
	# Dedicated end-to-end route: no teleports or direct damage from here onward.
	game.start_sample()
	while game.ui.dialog.visible: game.next_dialogue()
	await ticks(3)
	check("route_to_yuna",await navigate(Vector2(552,440)))
	game.interact()
	check("yuna_interaction",game.ui.dialog.visible)
	while game.ui.dialog.visible: game.next_dialogue()
	check("route_to_combat",await navigate(Vector2(689,572)))
	var combat_time := 0.0
	while not game.cleared and combat_time < 24 and not game.player.dead:
		var target: VillageEnemy = game.enemies[0]
		if not is_instance_valid(target): break
		var vector: Vector2 = target.position-game.player.position
		stop_move()
		if game.player.state in ["idle","move"]:
			game.player.set_facing(vector)
			if vector.length() > 31:
				if absf(vector.x) > 8: Input.action_press("move_right" if vector.x > 0 else "move_left")
				if absf(vector.y) > 8: Input.action_press("move_down" if vector.y > 0 else "move_up")
			else:
				Input.action_press("attack_heavy")
		else:
			Input.action_release("attack_heavy")
		await ticks(1)
		combat_time += 1.0/60
	stop_move()
	Input.action_release("attack_heavy")
	check("combat_via_input_no_damage_helper",game.cleared and not game.player.dead,"seconds="+str(combat_time))
	await seconds(.8)
	check("dead_enemy_cleanup",game.world.actors.get_children().filter(func(n): return n is VillageEnemy).is_empty())
	check("route_to_memorial",await navigate(Vector2(816,696)))
	game.interact()
	check("memorial_collected",game.memorial_found and game.ui.dialog.visible)
	while game.ui.dialog.visible: game.next_dialogue()
	check("route_to_shrine",await navigate(Vector2(520,273),20))
	game.interact()
	check("checkpoint_restores",game.checkpoint == Vector2(520,275) and game.player.hp == 100)
	check("route_to_bridge",await navigate(Vector2(1020,416),20))
	game.interact()
	check("sample_boundary_dialogue",game.ui.dialog.visible)
	while game.ui.dialog.visible: game.next_dialogue()
	check("save_write",game.save_progress())
	var save := SaveStore.read_save()
	check("save_roundtrip",save.get("checkpoint","") == "shrine" and save.get("cleared",false))
	game.save_progress()
	var corrupt := FileAccess.open(SaveStore.path(),FileAccess.WRITE)
	corrupt.store_string("bad json")
	corrupt.close()
	check("save_backup_recovery",not SaveStore.read_save().is_empty())
	game.return_menu()
	game.start_sample(true)
	await ticks(3)
	check("continue_checkpoint",game.player.position.distance_to(Vector2(520,275)) < 2 and game.cleared)
	game.return_menu()
	check("return_menu",game.ui.menu.visible and not game.running)
	var failures := checks.filter(func(c): return c.result == "FAIL")
	var report := {"engine":Engine.get_version_info(),"checks":checks,"pass":checks.size()-failures.size(),"fail":failures.size(),"controllers":Input.get_connected_joypads(),"scope":"sample only; integration fixtures plus separate input-driven sample route"}
	var file := FileAccess.open(game.evidence_dir.path_join("sample_qa.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print("SAMPLE_QA: ",report.pass," PASS / ",report.fail," FAIL")
	game.audio.shutdown()
	get_tree().paused = false
	await ticks(3)
	get_tree().quit(0 if failures.is_empty() else 1)
