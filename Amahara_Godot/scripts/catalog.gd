class_name Catalog
extends RefCounted

static func attacks() -> Dictionary:
	var result: Dictionary = {}
	for id in ["light_1", "light_2", "light_3", "heavy_1", "heavy_2", "heavy_3", "enemy_slash"]:
		result[id] = load("res://data/" + id + ".tres")
	return result

static func frame(sheet: Texture2D, col: int, row: int, columns: int, rows: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	var size := sheet.get_size() / Vector2(columns, rows)
	atlas.region = Rect2(Vector2(col, row) * size, size)
	return atlas

static func player_frames() -> SpriteFrames:
	var sheet: Texture2D = load("res://assets/ren_atlas.png")
	var actions: Texture2D = load("res://assets/ren_actions.png")
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	var poses := {"idle": [0], "walk": [0, 1, 0, 2], "windup": [3], "slash": [4], "reverse": [5], "finish": [6], "hurt": [7], "dash": [1], "cast": [3, 6], "death": [7]}
	var dirs := ["down", "left", "right", "up"]
	for row in range(4):
		for pose in poses:
			var anim: String = pose + "_" + dirs[row]
			frames.add_animation(anim)
			frames.set_animation_speed(anim, 9 if pose == "walk" else 5)
			if pose in ["dash","cast","death"]:
				frames.set_animation_loop(anim,false)
				if pose == "death":
					frames.add_frame(anim,frame(actions,2,row,4,4))
					frames.add_frame(anim,frame(actions,3,row,4,4))
				else: frames.add_frame(anim,frame(actions,0 if pose == "dash" else 1,row,4,4))
				continue
			for col in poses[pose]:
				frames.add_frame(anim, frame(sheet, col, row, 8, 4))
	return frames

static func prop_texture(index: int) -> AtlasTexture:
	var regions := [Rect2(0,0,350,350), Rect2(350,0,305,350), Rect2(655,0,330,350), Rect2(985,0,269,350),
		Rect2(0,350,350,320), Rect2(350,350,305,320), Rect2(655,350,330,320), Rect2(985,350,269,320),
		Rect2(0,670,350,258), Rect2(350,670,305,258), Rect2(655,670,330,258), Rect2(985,670,269,258),
		Rect2(0,928,350,326), Rect2(350,928,305,326), Rect2(655,928,330,326), Rect2(985,928,269,326)]
	var atlas := AtlasTexture.new()
	atlas.atlas = load("res://assets/props_atlas.png")
	atlas.region = regions[index]
	return atlas
