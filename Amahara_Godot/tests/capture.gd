extends Node

var output_dir := "res://evidence"

func frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame

func snap(file: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var code := image.save_png(output_dir.path_join(file+".png"))
	if code != OK:
		push_error("Could not save render capture: "+str(code))

func run(game) -> void:
	output_dir = game.evidence_dir
	await frames(8)
	await snap("01_menu")
	game.start_sample()
	await frames(5)
	await snap("02_dialogue")
	while game.ui.dialog.visible:
		game.next_dialogue()
	await get_tree().create_timer(1.0).timeout
	await snap("03_village")
	game.player.position = Vector2(822,426)
	await frames(8)
	await snap("04_bridge")
	game.player.position = Vector2(685,553)
	game.player.facing = Vector2.RIGHT
	game.player.start_attack("heavy_3")
	await get_tree().create_timer(.28).timeout
	await snap("05_combat")
	game.set_paused(true)
	game.ui.show_controls()
	await frames(5)
	await snap("06_controls")
	print("CAPTURE_OK: 6 rendered frames")
	game.close_game()
