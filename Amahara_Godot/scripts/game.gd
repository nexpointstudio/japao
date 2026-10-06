extends Node2D

var world: VillageWorld
var player: RenPlayer
var enemies: Array[VillageEnemy] = []
var boss: GeneralJinzo
var fx: BattleFX
var audio: AmaharaAudio
var ui: AmaharaUI
var camera: Camera2D
var projectiles: Node2D
var yuna: Node2D
var story := StoryProgression.new()
var director := EncounterDirector.new()
var targets := CombatTargetRegistry.new()
var session: GameSession
var hitstop: float = 0
var shake: float = 0
var running := false
var objective := ""
var dialogue: Array = []
var dialogue_done: Callable
var death_timer: Timer
var toast_timer: Timer
var generation: int = 0
var checkpoint := Vector2(512,416)
var settings: Dictionary = {}
var qa_mode := false
var evidence_dir := "res://evidence/final"
var boss_active := false
var ending_seen := false
var region := "AMAHARA / PRAÇA DO SINO"
var vibration := true
var deaths: int = 0
var closing := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().auto_accept_quit = false
	InputConfig.install()
	var args := OS.get_cmdline_user_args()
	for arg in args:
		if arg.begins_with("--evidence-dir="): evidence_dir = arg.trim_prefix("--evidence-dir=")
	qa_mode = "--qa" in args or "--capture" in args or "--playthrough" in args or "--advanced" in args or "--verify-save" in args or "--settings-qa" in args or "--foundation-qa" in args
	if qa_mode: SaveStore.override_path = "user://amahara_phase_qa.json"
	director.game = self
	audio = AmaharaAudio.new()
	add_child(audio)
	settings = load_settings()
	vibration = settings.get("vibration",true)
	audio.set_music_volume(float(settings.get("music",.55)))
	audio.sfx_volume = float(settings.get("sfx",.65))
	if settings.get("fullscreen",false) and not qa_mode: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	session = GameSession.new()
	add_child(session)
	session.respawn_requested.connect(respawn)
	session.reset_requested.connect(reset_enemies)
	death_timer = session.death_timer
	toast_timer = Timer.new()
	toast_timer.one_shot = true
	toast_timer.timeout.connect(func(): ui.toast_label.hide())
	add_child(toast_timer)
	create_world()
	ui = AmaharaUI.new()
	ui.game = self
	add_child(ui)
	get_tree().paused = true
	if "--qa" in args: call_deferred("run_suite","phase_suite")
	elif "--capture" in args: call_deferred("run_suite","phase_capture")
	elif "--playthrough" in args: call_deferred("run_suite","playthrough")
	elif "--advanced" in args: call_deferred("run_suite","advanced_suite")
	elif "--verify-save" in args: call_deferred("run_suite","persistence_probe")
	elif "--settings-qa" in args: call_deferred("run_suite","settings_suite")
	elif "--foundation-qa" in args: call_deferred("run_suite","foundation_suite")

func create_world() -> void:
	world = VillageWorld.new()
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world)
	fx = BattleFX.new()
	world.add_child(fx)
	projectiles = Node2D.new()
	world.add_child(projectiles)
	player = RenPlayer.new()
	player.name = "Ren"
	player.game = self
	player.position = checkpoint
	world.actors.add_child(player)
	player.died.connect(on_player_death)
	camera = Camera2D.new()
	camera.position_smoothing_enabled = false
	camera.limit_left = 60
	camera.limit_top = 65
	camera.limit_right = 3008
	camera.limit_bottom = 730
	camera.position = player.position
	world.add_child(camera)
	yuna = world.prop(12,Vector2(568,415),53,Vector2(14,12))
	yuna.name = "Yuna"
	var tint := CanvasModulate.new()
	tint.color = Color(.86,.91,.91)
	world.add_child(tint)

func start_sample(continue_save: bool = false) -> void:
	cancel_events()
	ui.clear_modal()
	ui.fade.color.a = 0
	ui.menu.hide()
	ui.hud.show()
	ui.toast_label.hide()
	story.restore(SaveStore.read_save() if continue_save else {})
	ending_seen = false
	deaths = 0
	apply_upgrades()
	checkpoint = story.checkpoint_position()
	session.start(player, "checkpoint.amahara."+story.checkpoint, checkpoint)
	camera.position = checkpoint
	running = true
	get_tree().paused = false
	sync_progress()
	if not continue_save:
		save_progress()
		open_dialogue([
			["YUNA · GUARDIÃ DE AMAHARA","O sino tocou sem vento, Ren. Até os pássaros deixaram a encosta."],
			["REN KUROGANE","Minha marca também sentiu. Fique perto das casas. Eu volto por você."],
			["AMAHARA","Ao sul da praça, dois guerreiros mortos erguem suas espadas. J: corte. K: golpe pesado. Espaço: esquiva."]])
	elif SaveStore.recovered_backup: toast("O registro foi recuperado pela cópia de segurança.")

func cancel_events() -> void:
	session.invalidate()
	generation = session.generation
	toast_timer.stop()
	dialogue.clear()
	dialogue_done = Callable()
	if is_instance_valid(ui): ui.dialog.hide()
	hitstop = 0
	shake = 0

func reset_enemies() -> void:
	director.reset()
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.dead = true
			enemy.queue_free()
	enemies.clear()
	if is_instance_valid(boss): boss.queue_free()
	boss = null
	boss_active = false
	clear_effects()
	if story.stage < 6:
		boss = GeneralJinzo.new()
		boss.game = self
		boss.position = Vector2(2816,432)
		world.actors.add_child(boss)
		boss.died.connect(on_boss_death)

func clear_effects() -> void:
	for p in projectiles.get_children(): p.queue_free()
	fx.motes.clear()
	fx.arcs.clear()
	fx.labels.clear()

func spawn_enemy(at: Vector2, kind: String = "swordsman") -> VillageEnemy:
	var enemy := VillageEnemy.new()
	enemy.game = self
	enemy.kind = kind
	enemy.position = at
	world.actors.add_child(enemy)
	enemies.append(enemy)
	return enemy

func combat_targets() -> Array:
	var result: Array = []
	for enemy in enemies:
		if is_instance_valid(enemy) and not enemy.dead: result.append(enemy)
	if is_instance_valid(boss) and not boss.dead: result.append(boss)
	return result

func launch_slash(at: Vector2, direction: Vector2) -> void:
	var slash := CelestialSlash.new()
	slash.game = self
	slash.position = at
	slash.direction = direction
	projectiles.add_child(slash)

func hostile_shot(source: Node2D, at: Vector2, direction: Vector2, damage: float) -> void:
	var shot := HostileEffect.new()
	shot.game = self
	shot.source = source
	shot.position = at
	shot.direction = direction
	shot.damage = damage
	shot.projectile = true
	projectiles.add_child(shot)

func hazard(source: Node2D, at: Vector2, radius: float, damage: float, delay: float) -> void:
	var area := HostileEffect.new()
	area.game = self
	area.source = source
	area.position = at
	area.radius = radius
	area.damage = damage
	area.delay = delay
	projectiles.add_child(area)

func open_dialogue(lines: Array, done: Callable = Callable()) -> void:
	dialogue = lines.duplicate(true)
	dialogue_done = done
	get_tree().paused = true
	ui.dialog.show()
	next_dialogue()

func next_dialogue() -> void:
	if dialogue.is_empty():
		ui.dialog.hide()
		get_tree().paused = false
		if dialogue_done.is_valid():
			var callback := dialogue_done
			dialogue_done = Callable()
			callback.call()
		return
	var line: Array = dialogue.pop_front()
	ui.speaker.text = line[0]
	ui.speech.text = line[1]

func nearest_interaction() -> Dictionary:
	if not player or player.dead: return {}
	if player.position.distance_to(yuna.position) < 49: return {"id":"yuna","label":"Falar com Yuna"}
	for interaction in world.interactions:
		if interaction.available(): return interaction.info
	return {}

func interaction_label() -> String:
	return nearest_interaction().get("label","")

func interact() -> void:
	if player.dead or player.state in ["attack","dash","hurt","cast"]: return
	var found := nearest_interaction()
	match found.get("id",""):
		"yuna":
			if story.stage == 1:
				open_dialogue([["YUNA","Reconheço essa armadura. Os homens de Jinzō foram sepultados com ele há oitenta anos."],["REN","O chamado veio da encosta. Vou seguir a estrada."],["YUNA","Prometa voltar como você é, Ren. Há um santuário depois da floresta. Firme seu juramento lá."]],func(): story.advance(2); sync_progress(); save_progress())
			elif story.stage == 6: conclusion()
			else: open_dialogue([["YUNA","Eu estarei aqui. Observe os golpes, use a esquiva e deixe a espada recuperar sua energia."]])
		"village_shrine":
			if nearby_threat(): toast("Afaste os mortos antes de descansar.")
			else: heal_at_shrine(false)
		"sanctuary":
			if story.stage < 3: toast("Siga primeiro o rastro dos mortos.")
			elif nearby_threat(): toast("O santuário espera o silêncio. Afaste os mortos.")
			else:
				story.checkpoint = "sanctuary"
				story.advance(4)
				story.checkpoint_changed.emit("sanctuary")
				heal_at_shrine(true)
		"altar":
			if story.collect("altar"):
				apply_upgrades()
				player.energy = player.max_energy
				save_progress()
				open_dialogue([["VOTO DO ESTANDARTE","A marca em sua mão aquece o altar. Energia Divina máxima +25."],["REN","Não peço uma guerra. Só força para trazer os meus de volta."]])
			else: toast("O voto já foi recebido. Energia máxima: 125.")
		"memorial":
			if story.collect("memorial"):
				var reward: UpgradeData = load("res://data/memorial.tres")
				player.hp = minf(player.max_hp,player.hp+reward.recovery_bonus)
				save_progress()
				open_dialogue([["MEMORIAL DOS AUSENTES","Uma faixa ainda guarda os nomes dos soldados. Você a recolhe. Vida +35."],["INSCRIÇÃO","Ao regressarem, deixem as armas sob a árvore. Lembraremos seus nomes, não suas vitórias."]])
			else: open_dialogue([["FAIXA DOS AUSENTES","A faixa está com Ren. Os nomes sobreviverão a esta noite."]])
		"inscription": open_dialogue([["INSCRIÇÃO DA ALDEIA","Três sinos guardam os caminhos dos mortos. Nenhum deve tocar sozinho."]])
		"survivor": open_dialogue([["SOBREVIVENTE","A ponte resistiu. Siga a estrada para leste; na pedra caída, contorne pelo norte."],["SOBREVIVENTE","Há um memorial ao norte da floresta e um altar ao sul. Um portão velho encurta o retorno do santuário."]])
		"shortcut":
			if player.position.x < 1888: toast("A tranca está do outro lado.")
			elif not story.shortcut:
				story.shortcut = true
				sync_progress()
				save_progress()
				toast("Atalho aberto: santuário ↔ altar da floresta.")
			else: toast("O caminho de volta está aberto.")
		"exit": toast("Siga pela ponte e procure o santuário a leste." if story.stage >= 2 else "Yuna precisa falar com você antes da partida.")
		"arena": toast("O general aguarda além do torii." if story.stage >= 5 else "Firme o checkpoint e derrote a guarda de elite.")
		"ending":
			if story.stage == 6: conclusion()
			else: toast("O sino permanece sob o juramento de Jinzō.")

func nearby_threat() -> bool:
	for enemy in combat_targets():
		if enemy.position.distance_to(player.position) < 175: return true
	return false

func heal_at_shrine(is_checkpoint: bool) -> void:
	player.hp = player.max_hp
	player.energy = player.max_energy
	checkpoint = story.checkpoint_position()
	sync_progress()
	save_progress()
	audio.sfx("shrine")
	fx.ring(player.position,46,Color("7fc9ad"),.8)
	toast("Vida e energia restauradas. " + ("Checkpoint firmado." if is_checkpoint else "A aldeia guarda seu retorno."))

func apply_upgrades() -> void:
	var upgrade: UpgradeData = load("res://data/altar.tres")
	player.max_energy = 100+upgrade.energy_bonus if "altar" in story.upgrades else 100

func sync_progress() -> void:
	session.set_checkpoint("checkpoint.amahara."+story.checkpoint,story.checkpoint_position())
	objective = story.objective()
	world.set_gate("village",story.stage < 2)
	world.set_gate("shortcut",not story.shortcut)
	world.set_gate("arena",story.stage < 5 or boss_active)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo: return
	if event.is_action_pressed("pause") and running:
		if ui.dialog.visible or player.dead: return
		if get_tree().paused:
			ui.clear_modal()
			set_paused(false)
		else:
			set_paused(true)
			ui.show_pause()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact") and running:
		if ui.dialog.visible: next_dialogue()
		elif not get_tree().paused: interact()
		get_viewport().set_input_as_handled()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F11: toggle_fullscreen()

func _process(dt: float) -> void:
	if running and not get_tree().paused:
		hitstop = maxf(0,hitstop-dt)
		shake = maxf(0,shake-dt*15)
		camera.position = player.position.round()
		camera.offset = Vector2(randf_range(-shake,shake),randf_range(-shake,shake)).round()
		if not player.dead:
			director.tick(dt)
			if story.stage == 2 and player.position.x > 2120:
				story.advance(3)
				sync_progress()
			if story.stage == 5 and player.position.x > 2585 and not boss_active: enter_boss()
		region = "AMAHARA / PRAÇA DO SINO" if player.position.x < 1120 else "FLORESTA DOS AUSENTES" if player.position.x < 1856 else "ENCOSTA CORROMPIDA" if player.position.x < 2120 else "SANTUÁRIO DO JURAMENTO" if player.position.x < 2528 else "JINZŌ / TÚMULO DE GUERRA"
	if is_instance_valid(ui): ui.refresh()

func enter_boss() -> void:
	boss_active = true
	sync_progress()
	# Remove pursuing field enemies before sealing the duel.
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.dead = true
			enemy.queue_free()
	enemies.clear()
	director.tokens.clear()
	clear_effects()
	open_dialogue([["GENERAL JINZŌ","Essa marca... ainda há sangue do Estandarte entre os vivos."],["REN KUROGANE","Quem tirou você da sepultura?"],["GENERAL JINZŌ","Eu também respondi ao chamado. E meu juramento exige que ninguém passe."]],func(): boss.awaken(); audio.change_track("boss"))

func on_boss_death() -> void:
	boss_active = false
	story.advance(6)
	clear_effects()
	sync_progress()
	save_progress()
	audio.change_track("village")
	open_dialogue([["JINZŌ","Três sinos... três sepulturas. O primeiro não chamou apenas a mim."],["REN","Então ainda há alguém ouvindo."],["JINZŌ","Alguém conhece o sangue que corre sob essa marca."]],func(): conclusion())

func conclusion() -> void:
	if story.stage != 6: return
	open_dialogue([["YUNA","Você voltou. Por um instante, o sino soou como uma despedida."],["REN","Jinzō também foi chamado. Não era ele quem puxava a corda."],["AMAHARA · FIM DA FASE 1","A aldeia respira. Ao longe, dois sinos permanecem em silêncio. Ren guarda a katana; o juramento continua."]],func(): ending_seen = true; ui.show_victory())

func camera_bump(amount: float) -> void: shake = maxf(shake,amount)

func rumble(weak: float, strong: float, duration: float) -> void:
	if not vibration: return
	for id in Input.get_connected_joypads(): Input.start_joy_vibration(id,weak,strong,duration)

func toast(text: String) -> void:
	ui.toast_label.text = text
	ui.toast_label.show()
	toast_timer.start(3.2)

func on_player_death() -> void:
	deaths += 1
	objective = "O juramento ainda não terminou."
	session.mark_dead(1.1)
	ui.fade.color.a = .55

func respawn() -> void:
	cancel_events()
	get_tree().paused = false
	checkpoint = story.checkpoint_position()
	session.respawn_at("checkpoint.amahara."+story.checkpoint, checkpoint)
	ui.fade.color.a = 0
	sync_progress()
	audio.change_track("village")
	toast("Você despertou no último santuário.")

func set_paused(value: bool) -> void: get_tree().paused = value

func return_menu() -> void:
	cancel_events()
	session.end()
	ui.clear_modal()
	ui.hud.hide()
	ui.toast_label.hide()
	ui.fade.color.a = 0
	ui.menu.show()
	ui.menu_buttons[1].disabled = SaveStore.read_save().is_empty()
	ui.menu_buttons[0].grab_focus()
	running = false
	get_tree().paused = true
	audio.change_track("village")

func save_progress() -> bool:
	var ok := SaveStore.write_save(story.snapshot())
	if not ok: toast("Não foi possível salvar o juramento neste dispositivo.")
	return ok

func persist_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio","music",audio.music_volume)
	config.set_value("audio","sfx",audio.sfx_volume)
	config.set_value("input","vibration",vibration)
	config.set_value("display","fullscreen",DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	config.save("user://phase_qa_settings.cfg" if qa_mode else "user://settings.cfg")

func load_settings() -> Dictionary:
	var config := ConfigFile.new()
	config.load("user://phase_qa_settings.cfg" if qa_mode else "user://settings.cfg")
	return {"music":clampf(float(config.get_value("audio","music",.55)),0,1),"sfx":clampf(float(config.get_value("audio","sfx",.65)),0,1),"vibration":config.get_value("input","vibration",true),"fullscreen":config.get_value("display","fullscreen",false)}

func toggle_fullscreen() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN)
	persist_settings()

func close_game(exit_code: int = 0) -> void:
	if closing: return
	closing = true
	get_tree().paused = false
	audio.shutdown()
	await get_tree().create_timer(.5).timeout
	get_tree().quit(exit_code)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST: close_game()

func run_suite(id: String) -> void:
	var suite = load("res://tests/"+id+".gd").new()
	add_child(suite)
	await suite.run(self)
