extends SceneTree
var player: AudioStreamPlayer
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	player = AudioStreamPlayer.new()
	root.add_child(player)
	player.stream = load("res://assets/audio/village.wav")
	player.play()
	await create_timer(.3).timeout
	player.stop()
	player.stream = null
	player.queue_free()
	await create_timer(.5).timeout
	quit()
