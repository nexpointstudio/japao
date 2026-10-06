extends Node

var game
func snap(id: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(game.evidence_dir+"/"+id+".png")
	print("CAPTURE "+id)

func run(g) -> void:
	game = g
	DirAccess.make_dir_recursive_absolute(game.evidence_dir)
	await snap("01_menu")
	game.start_sample()
	while game.ui.dialog.visible: game.next_dialogue()
	game.story.stage = 5
	game.story.completed = ["village","forest","bridge","corruption","elite"]
	game.story.checkpoint = "sanctuary"
	game.sync_progress()
	for entry in [["02_village",Vector2(585,416)],["03_forest",Vector2(1450,416)],["04_altar",Vector2(1712,670)],["05_corruption",Vector2(2010,275)],["06_sanctuary",Vector2(2208,424)],["07_jinzo",Vector2(2710,440)]]:
		game.player.restore(entry[1])
		await get_tree().create_timer(.2).timeout
		while game.ui.dialog.visible: game.next_dialogue()
		game.set_paused(true)
		await snap(entry[0])
		game.set_paused(false)
	game.boss.hp = 235
	await get_tree().create_timer(.2).timeout
	game.set_paused(true)
	await snap("08_jinzo_phase2")
	game.story.stage = 6
	game.boss_active = false
	game.ui.show_victory()
	await snap("09_conclusion")
	game.close_game()
