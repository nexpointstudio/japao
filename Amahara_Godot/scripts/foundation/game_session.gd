class_name GameSession
extends Node

signal reset_requested
signal player_died
signal respawn_requested
signal respawned
signal region_change_requested(region_id: String)

var active_player: Node2D
var state := "menu"
var checkpoint_id := ""
var checkpoint_position := Vector2.ZERO
var generation: int = 0
var persistent := PersistentWorldState.new()
var death_timer: Timer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	death_timer = Timer.new()
	death_timer.one_shot = true
	death_timer.timeout.connect(func():
		if state == "dead": respawn_requested.emit())
	add_child(death_timer)

func invalidate() -> void:
	generation += 1
	death_timer.stop()

func current(token: int) -> bool:
	return token == generation and state != "menu"

func start(actor: Node2D, id: String, at: Vector2) -> void:
	active_player = actor
	persistent = PersistentWorldState.new()
	respawn_at(id, at)

func respawn_at(id: String, at: Vector2) -> void:
	if not set_checkpoint(id, at): return
	invalidate()
	state = "running"
	if is_instance_valid(active_player) and active_player.has_method("restore"): active_player.restore(at)
	reset_requested.emit()
	respawned.emit()

func set_checkpoint(id: String, at: Vector2) -> bool:
	if not PersistentIds.valid(id) or not id.begins_with("checkpoint.") or not at.is_finite(): return false
	checkpoint_id = id
	persistent.checkpoint = id
	checkpoint_position = at
	return true

func mark_dead(delay: float) -> void:
	if state != "running": return
	state = "dead"
	player_died.emit()
	death_timer.start(delay)

func end() -> void:
	invalidate()
	state = "menu"
	active_player = null

func request_region(id: String) -> bool:
	if not PersistentIds.valid(id) or not id.begins_with("region."): return false
	invalidate()
	region_change_requested.emit(id)
	return true

func save_state(file_path: String = SaveStore.WORLD_PATH) -> bool:
	return SaveStore.write_world(persistent.snapshot(), file_path)

func load_state(file_path: String = SaveStore.WORLD_PATH) -> bool:
	return persistent.restore(SaveStore.read_world(file_path))
