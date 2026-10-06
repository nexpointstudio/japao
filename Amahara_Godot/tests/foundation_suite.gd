extends Node

class DummyTarget extends CharacterBody2D:
	var dead := false
	var hp: float = 100
	var received: CombatHit
	func receive_combat_hit(hit: CombatHit) -> bool:
		received = hit
		hp -= hit.damage
		return true
	func restore(at: Vector2) -> void:
		position = at
		hp = 100
		dead = false

var checks: Array = []
func check(id: String, ok: bool) -> void:
	checks.append({"id":id,"pass":ok})
	print("PASS " if ok else "FAIL ",id)

func same(a: Variant, b: Variant) -> bool:
	if (a is int or a is float) and (b is int or b is float): return is_equal_approx(float(a),float(b))
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): return false
		for key in a:
			if not b.has(key) or not same(a[key],b[key]): return false
		return true
	if a is Array and b is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not same(a[i],b[i]): return false
		return true
	return a == b

func ticks(n: int = 3) -> void:
	for i in n: await get_tree().physics_frame

func run(game) -> void:
	game.start_sample()
	while game.ui.dialog.visible: game.next_dialogue()
	game.player.set_physics_process(false)
	game.boss.set_physics_process(false)
	game.director.active = {"village":[],"forest":[],"bridge":[],"corruption":[],"elite":[]}
	var dummy := DummyTarget.new()
	game.world.actors.add_child(dummy)
	dummy.position = Vector2(546,416)
	game.targets.register(dummy,CombatFactions.Team.ENEMY)
	var hurt := HurtboxComponent.new()
	hurt.setup(dummy,8,Vector2(16,26))
	dummy.add_child(hurt)
	var hit := CombatHit.create(game.player,dummy,7,13,5,"fixture.attack.1")
	hit.damage_type = &"fixture_custom"
	hit.source_kind = &"fixture"
	hit.properties = {"hitbox_ref":"fixture.blade"}
	check("hit_accept",hit.apply())
	check("hit_fields",dummy.hp == 93 and dummy.received == hit and hit.stagger == 5 and hit.knockback == 13 and hit.origin == game.player.global_position and hit.direction == Vector2.RIGHT and hit.target == dummy and hit.attacker == game.player and hit.properties.hitbox_ref == "fixture.blade")
	hit.damage = -1
	check("hit_negative_rejected",not hit.apply())
	hit.damage = NAN
	check("hit_nan_rejected",not hit.apply())
	hit.damage = 7
	game.player.facing = Vector2.RIGHT
	game.player.hitbox.begin(game.player.attacks.light_1,Vector2.RIGHT)
	await ticks()
	game.player.hitbox.sample()
	check("native_hitbox_contract",dummy.hp == 82 and dummy.received.attack_id.begins_with("light_1:"))
	game.player.hitbox.sample()
	check("native_single_hit",dummy.hp == 82)
	game.player.hitbox.finish()
	check("enemy_player_hostile",CombatFactions.hostile(dummy,game.player))
	var ally := DummyTarget.new()
	game.world.actors.add_child(ally)
	ally.position = Vector2(600,480)
	game.targets.register(ally,CombatFactions.Team.ALLY)
	check("player_ally_friendly",not CombatFactions.hostile(ally,game.player))
	check("friendly_damage_rejected",not CombatHit.create(game.player,ally,8).apply() and ally.hp == 100)
	var enemy = game.spawn_enemy(Vector2(620,480))
	enemy.set_physics_process(false)
	check("enemy_enemy_friendly",not CombatFactions.hostile(enemy,dummy))
	check("nearest_non_ren",game.targets.nearest(enemy) == ally)
	game.hitstop = 0
	enemy.state = "chase"
	enemy._physics_process(.01)
	check("enemy_targets_ally",enemy.combat_target == ally and enemy.state == "telegraph")
	enemy.cancel_attack()
	game.boss.position = Vector2(600,416)
	game.boss.begin_pattern("charge")
	check("boss_targets_ally",game.boss.combat_target == ally)
	ally.dead = true
	check("dead_target_excluded",game.targets.nearest(enemy) == game.player)
	ally.dead = false
	game.targets.register(ally,CombatFactions.Team.NEUTRAL)
	check("neutral_excluded",not CombatFactions.hostile(enemy,ally))
	game.targets.unregister(ally)
	ally.queue_free()
	dummy.queue_free()
	enemy.dead = true
	enemy.queue_free()
	await ticks()
	check("freed_target_pruned",game.targets.nearest(game.player) == game.boss)
	var ids := PersistentIds.new()
	check("id_valid",ids.claim("checkpoint.fixture.start"))
	check("id_duplicate",not ids.claim("checkpoint.fixture.start"))
	check("id_bad",not ids.claim("../bad") and not PersistentIds.valid("unknown.item") and not PersistentIds.valid("boss..empty"))
	var state := PersistentWorldState.new()
	state.checkpoint = "checkpoint.fixture.start"
	state.flags["flag.fixture.seen"] = true
	state.completed = ["boss.fixture.one"]
	state.unlocked = ["magic.fixture.one"]
	state.upgrades = ["upgrade.fixture.one"]
	state.progress["story.fixture"] = 2
	var payload := state.snapshot()
	check("state_version",payload.version == 3 and PersistentWorldState.validate(payload))
	var restored := PersistentWorldState.new()
	check("state_roundtrip",restored.restore(JSON.parse_string(JSON.stringify(payload))) and same(restored.snapshot(),payload))
	var invalid := payload.duplicate(true)
	invalid.completed.append("boss.fixture.one")
	check("state_duplicate_rejected",not restored.restore(invalid) and same(restored.snapshot(),payload))
	invalid = payload.duplicate(true)
	invalid.version = 999
	check("future_save_rejected",not PersistentWorldState.validate(invalid))
	invalid = payload.duplicate(true)
	invalid.progress["story.fixture"] = -1
	check("negative_progress_rejected",not PersistentWorldState.validate(invalid))
	var file_path: String = game.evidence_dir+"/foundation_world.json"
	check("world_save_write",SaveStore.write_world(payload,file_path))
	check("world_disk_read",same(SaveStore.read_world(file_path),payload))
	state.flags["flag.fixture.second"] = true
	check("world_backup_write",SaveStore.write_world(state.snapshot(),file_path))
	var broken := FileAccess.open(file_path,FileAccess.WRITE)
	broken.store_string("{corrupt")
	broken.close()
	check("world_backup_recovery",same(SaveStore.read_world(file_path),payload) and SaveStore.world_recovered_backup)
	check("bad_state_never_written",not SaveStore.write_world(invalid,file_path))
	check("backup_not_overwritten_by_corrupt_main",SaveStore.write_world(payload,file_path) and PersistentWorldState.validate(JSON.parse_string(FileAccess.get_file_as_string(file_path+".bak"))))
	var previous_path := SaveStore.override_path
	SaveStore.override_path = game.evidence_dir+"/legacy_v1.json"
	var legacy := FileAccess.open(SaveStore.path(),FileAccess.WRITE)
	legacy.store_string('{"version":1,"cleared":true}')
	legacy.close()
	var migrated := SaveStore.read_save()
	check("legacy_v1_migration",migrated.get("version") == 2 and migrated.get("stage") == 1)
	check("legacy_v2_roundtrip",SaveStore.write_save(migrated) and same(SaveStore.read_save(),migrated))
	check("world_rejects_legacy_namespace",not PersistentWorldState.validate(migrated))
	SaveStore.override_path = previous_path
	var doc = JSON.parse_string(FileAccess.get_file_as_string("res://contracts/fixture.anim.json"))
	check("animation_fixture_valid",AnimationContract.validate(doc).is_empty())
	for entry in [["schema", "schema_version", 9],["version", "revision",0]]:
		var bad: Dictionary = doc.duplicate(true)
		bad[entry[1]] = entry[2]
		check("animation_bad_"+entry[0],not AnimationContract.validate(bad).is_empty())
	for entry in [["fps",0],["pivot",null],["frames",[]],["duration",99],["loop","yes"]]:
		var bad: Dictionary = doc.duplicate(true)
		bad.animations[0][entry[0]] = entry[1]
		check("animation_invalid_"+entry[0],not AnimationContract.validate(bad).is_empty())
	var duplicate: Dictionary = doc.duplicate(true)
	duplicate.animations.append(doc.animations[0].duplicate(true))
	check("animation_duplicate_id",not AnimationContract.validate(duplicate).is_empty())
	var event_bad: Dictionary = doc.duplicate(true)
	event_bad.animations[0].events[0].frame = 8
	check("animation_event_bounds",not AnimationContract.validate(event_bad).is_empty())
	var frame_bad: Dictionary = doc.duplicate(true)
	frame_bad.animations[0].frames[0].rect = [0,0,999,999]
	check("animation_texture_bounds",not AnimationContract.validate(frame_bad).is_empty())
	var fresh := GameSession.new()
	add_child(fresh)
	var actor := DummyTarget.new()
	add_child(actor)
	fresh.start(actor,"checkpoint.fixture.start",Vector2(10,20))
	check("session_no_narrative",fresh.state == "running" and actor.position == Vector2(10,20))
	check("session_bad_checkpoint",not fresh.set_checkpoint("boss.fixture.one",Vector2.ZERO))
	game.story.checkpoint = "sanctuary"
	game.sync_progress()
	check("session_checkpoint_adapter",game.session.checkpoint_id == "checkpoint.amahara.sanctuary" and game.session.checkpoint_position == game.story.checkpoint_position())
	var token := fresh.generation
	fresh.mark_dead(.05)
	fresh.end()
	await get_tree().create_timer(.08).timeout
	check("session_reset_invalidates",not fresh.current(token) and fresh.state == "menu" and fresh.death_timer.is_stopped())
	fresh.start(actor,"checkpoint.fixture.start",Vector2(4,5))
	fresh.persistent = restored
	check("session_persistence",fresh.save_state(file_path) and fresh.load_state(file_path))
	check("session_region_contract",fresh.request_region("region.fixture.next") and not fresh.request_region("boss.fixture.one"))
	fresh.queue_free()
	actor.queue_free()
	await ticks()
	var fail := checks.filter(func(c): return not c.pass).size()
	var report := FileAccess.open(game.evidence_dir+"/foundation_qa.json",FileAccess.WRITE)
	report.store_string(JSON.stringify({"pass":checks.size()-fail,"fail":fail,"checks":checks},"\t"))
	report.close()
	print("FOUNDATION_QA ",checks.size()-fail," PASS / ",fail," FAIL")
	game.close_game(1 if fail else 0)
