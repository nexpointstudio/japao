extends Node

# Reads state to choose inputs. Never sets HP, position, damage, stage, energy or cooldowns.
var game
var trace: Array = []
var tick: int = 0
var route := PackedVector2Array()
var route_clock: int = 0
var goal := Vector2.ZERO
var last_stage: int = -1
var captures: Dictionary = {}
var steps: Array = [Vector2(710,566),Vector2(552,440),Vector2(1020,416),Vector2(1240,416),Vector2(1475,280),Vector2(1660,425),Vector2(1712,675),Vector2(1820,270),Vector2(2030,270),Vector2(2010,425),Vector2(2208,424),Vector2(1918,574),Vector2(2208,424),Vector2(2420,435),Vector2(2208,424),Vector2(2630,435)]
var step: int = 0
var interacted: Dictionary = {}
var wall_start: int
var render_start: int

func release() -> void:
	for action in ["move_left","move_right","move_up","move_down","attack_light","attack_heavy","dash","magic_1","magic_2"]: Input.action_release(action)

func move(direction: Vector2) -> void:
	if absf(direction.x) > .2: Input.action_press("move_right" if direction.x > 0 else "move_left")
	if absf(direction.y) > .2: Input.action_press("move_down" if direction.y > 0 else "move_up")

func event(action: String) -> void:
	var e := InputEventAction.new()
	e.action = action
	e.pressed = true
	Input.parse_input_event(e)
	var up := InputEventAction.new()
	up.action = action
	up.pressed = false
	Input.parse_input_event(up)

func log_event(text: String) -> void:
	print("RUN ",tick," ",text," hp=",game.player.hp," at=",game.player.position)
	trace.append({"tick":tick,"event":text,"hp":game.player.hp,"x":game.player.position.x,"y":game.player.position.y})

func screenshot(id: String) -> void:
	if DisplayServer.get_name() == "headless" or captures.has(id): return
	captures[id] = true
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(game.evidence_dir+"/run_"+id+".png")

func run(g) -> void:
	game = g
	wall_start = Time.get_ticks_msec()
	render_start = Engine.get_process_frames()
	DirAccess.make_dir_recursive_absolute(game.evidence_dir)
	Engine.time_scale = 3
	Engine.physics_ticks_per_second = 180
	game.ui.menu_buttons[0].pressed.emit()
	for frame in 60000:
		tick = frame
		release()
		if game.ui.dialog.visible:
			if frame%15 == 0: event("interact")
		elif game.ending_seen:
			await screenshot("victory")
			break
		elif game.player.dead:
			pass
		else:
			if game.story.stage != last_stage:
				last_stage = game.story.stage
				log_event("STAGE "+str(last_stage))
				screenshot("stage_"+str(last_stage))
			if frame%600 == 0: log_event("STEP "+str(step))
			var nearest = null
			var distance := 185.0
			for enemy in game.combat_targets():
				if enemy.state == "dormant": continue
				var d: float = enemy.position.distance_to(game.player.position)
				if d < distance:
					nearest = enemy
					distance = d
			if nearest != null:
				fight(nearest,distance)
			elif step < steps.size():
				travel(steps[step])
			else:
				travel(Vector2(2770,432))
		await get_tree().physics_frame
	release()
	var report := {"pass":game.ending_seen and game.story.stage == 6,"stage":game.story.stage,"ticks":tick,"deaths":game.deaths,"upgrades":game.story.upgrades,"shortcut":game.story.shortcut,"completed":game.story.completed,"trace":trace,"method":"Menu button and InputMap events only; no teleports or stat edits. Simulation accelerated 3x, 180 physics ticks/s."}
	report["wall_seconds"] = (Time.get_ticks_msec()-wall_start)/1000.0
	report["average_process_fps"] = (Engine.get_process_frames()-render_start)/report.wall_seconds
	report["rendered"] = DisplayServer.get_name() != "headless"
	report["boss_patterns_observed"] = game.boss.performed if is_instance_valid(game.boss) else []
	report["boss_transitions"] = game.boss.transitions if is_instance_valid(game.boss) else 0
	var f := FileAccess.open(game.evidence_dir+"/playthrough.json",FileAccess.WRITE)
	f.store_string(JSON.stringify(report,"\t"))
	f.close()
	print("PLAYTHROUGH ",report.pass)
	Engine.time_scale = 1
	Engine.physics_ticks_per_second = 60
	game.close_game()

func fight(enemy, distance: float) -> void:
	var delta: Vector2 = enemy.position-game.player.position
	var dir := delta.normalized()
	var danger: bool = enemy.state == "telegraph" and enemy.timer < .25
	if enemy is GeneralJinzo and enemy.state == "telegraph" and enemy.pattern.id == "wide":
		move(-dir)
		if distance < 100 and game.player.dash_cd <= 0: Input.action_press("dash")
		return
	if danger and distance < 72 and game.player.state in ["idle","move"] and game.player.dash_cd <= 0:
		move(dir.orthogonal())
		Input.action_press("dash")
		return
	if game.player.state == "attack":
		if game.player.attack_elapsed > game.player.current_attack.duration()-.18 and tick%2 == 0:
			Input.action_press("attack_heavy")
		return
	if distance > 31:
		move(dir)
		if enemy.kind == "archer" if enemy is VillageEnemy else false:
			if distance > 100 and game.player.dash_cd <= 0: Input.action_press("dash")
	else:
		move(dir)
		if tick%2 == 0:
			if game.player.cast_cd[1] <= 0 and game.player.energy >= 35: Input.action_press("magic_2")
			else: Input.action_press("attack_heavy")

func travel(target: Vector2) -> void:
	if game.player.position.distance_to(target) < 20:
		if step in [1,4,6,10,11,12,14]:
			if not interacted.has(step):
				event("interact")
				interacted[step] = true
				log_event("INTERACT "+str(step))
				return
		step += 1
		route.clear()
		return
	if goal != target or route_clock <= tick or route.is_empty():
		goal = target
		route_clock = tick+30
		route = game.world.route(game.player.position,target)
	while not route.is_empty() and game.player.position.distance_to(route[0]) < 8: route.remove_at(0)
	var point := target if route.is_empty() else route[0]
	move(game.player.position.direction_to(point))
