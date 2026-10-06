class_name EncounterDirector
extends RefCounted

var game
var tokens: Array = []
var active: Dictionary = {}
var cooldown: float = 0
const ENCOUNTERS := {
	"village": [["swordsman",740,571],["swordsman",794,600]],
	"forest": [["swordsman",1300,410],["runner",1420,456]],
	"bridge": [["heavy",1660,408],["archer",1790,435]],
	"corruption": [["seal",1976,380],["runner",1910,470],["swordsman",2030,435],["archer",2050,340]],
	"elite": [["heavy",2380,413],["seal",2440,475],["archer",2450,360]]}

func tick(dt: float) -> void:
	cooldown = maxf(0,cooldown-dt)
	tokens = tokens.filter(func(e): return is_instance_valid(e) and not e.dead and e.state in ["telegraph","attack"])
	for id in ENCOUNTERS:
		if id in game.story.completed or active.has(id): continue
		if id == "elite" and game.story.stage < 4: continue
		if id != "village" and game.story.stage < 2: continue
		var row: Array = ENCOUNTERS[id][0]
		if game.player.position.distance_to(Vector2(row[1],row[2])) < 300:
			spawn_group(id)

func spawn_group(id: String) -> void:
	active[id] = []
	for row in ENCOUNTERS[id]:
		var enemy = game.spawn_enemy(Vector2(row[1],row[2]),row[0])
		active[id].append(enemy)
		enemy.died.connect(func(): on_death(id))

func request(enemy) -> bool:
	if enemy in tokens: return true
	if tokens.size() >= 2 or cooldown > 0: return false
	tokens.append(enemy)
	cooldown = .32
	return true

func release(enemy) -> void:
	tokens.erase(enemy)

func on_death(id: String) -> void:
	if not active.has(id): return
	for enemy in active[id]:
		if is_instance_valid(enemy) and not enemy.dead: return
	if not id in game.story.completed:
		game.story.completed.append(id)
		game.player.hp = minf(game.player.max_hp,game.player.hp+18)
		game.fx.word(game.player.position,"+18 VIDA",Color("9ed5a4"))
		if id == "village": game.story.advance(1)
		if id == "elite": game.story.advance(5)
		game.sync_progress()
		game.save_progress()

func reset() -> void:
	tokens.clear()
	active.clear()
	cooldown = 0
