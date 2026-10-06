class_name VillageWorld
extends Node2D

const SIZE := Vector2i(96, 24)
var gates: Dictionary = {}
var gate_rects: Dictionary = {}
var gate_closed: Dictionary = {}
var interactions: Array[WorldInteraction] = []
var actors: Node2D
var navigation := AStarGrid2D.new()
var blocked: Array[Rect2] = []
var landmarks: Array[Dictionary] = []
var clock: float = 0.0
var leaves: Array[Vector2] = []
var world_time: float = 0.0
var ground: TileMapLayer
var light_texture: ImageTexture

func _ready() -> void:
	build()

func build() -> void:
	ground = TileMapLayer.new()
	ground.name = "Ground"
	ground.z_index = -2
	ground.tile_set = make_tiles()
	add_child(ground)
	for y in SIZE.y:
		for x in SIZE.x:
			var kind := 0
			if is_path(x,y):
				kind = 1
			if x >= 28 and x <= 30:
				kind = 2
			if x >= 28 and x <= 30 and y >= 12 and y <= 13:
				kind = 3
			if kind == 1:
				var mask := 0
				if not is_path(x,y-1): mask |= 1
				if not is_path(x+1,y): mask |= 2
				if not is_path(x,y+1): mask |= 4
				if not is_path(x-1,y): mask |= 8
				if mask > 0: kind = 4+mask
			if x >= 58 and x < 66: kind = 20 if kind == 0 else 21
			if x >= 80 and y >= 8 and y <= 20: kind = 22
			ground.set_cell(Vector2i(x,y), 0, Vector2i(kind, (x * 13 + y * 7) % 4))
	actors = Node2D.new()
	actors.name = "ObjectsAndActors"
	actors.y_sort_enabled = true
	add_child(actors)
	# Each landmark has a native collider at its footprint; tree canopies remain traversable.
	prop(0, Vector2(335,355), 208, Vector2(139,63))
	prop(1, Vector2(748,348), 180, Vector2(126,56))
	prop(0, Vector2(334,678), 192, Vector2(130,58))
	prop(4, Vector2(520,235), 105, Vector2(62,35))
	prop(7, Vector2(646,548), 69, Vector2(39,24))
	prop(9, Vector2(201,598), 111, Vector2(87,40))
	prop(9, Vector2(201,654), 106, Vector2(84,39))
	prop(11, Vector2(817,670), 65, Vector2(25,20))
	landmarks.append({"id":"inscription", "pos":Vector2(817,680), "label":"Ler a inscrição"})
	landmarks.append({"id":"village_shrine", "pos":Vector2(520,251), "label":"Descansar no santuário"})
	landmarks.append({"id":"exit", "pos":Vector2(1040,415), "label":"Caminho da floresta"})
	for x in [128,240,378,687,839,1010]:
		prop(2, Vector2(x,176 + (int(x) % 3) * 12), 155, Vector2(22,18))
	for at in [Vector2(148,390),Vector2(97,545),Vector2(870,333),Vector2(734,719),Vector2(1100,303),Vector2(1080,665)]:
		prop(2, at, 145, Vector2(22,18))
	for at in [Vector2(863,253),Vector2(856,571),Vector2(1024,530),Vector2(1024,252),Vector2(132,680)]:
		prop(3, at, 110, Vector2(24,15))
	for at in [Vector2(400,520), Vector2(747,492), Vector2(559,643), Vector2(115,300)]:
		prop(8, at, 42, Vector2(26,12))
	for at in [Vector2(422,365),Vector2(658,353),Vector2(481,254),Vector2(563,254),Vector2(884,426),Vector2(1000,426)]:
		prop(6, at, 45, Vector2(14,12))
		lantern(at + Vector2(0,-25))
	for x in range(260,435,54):
		prop(10,Vector2(x,513),62,Vector2(52,8))
	prop(5, Vector2(1030,391), 113, Vector2.ZERO)
	build_expansion()
	for landmark in landmarks:
		var interaction := WorldInteraction.new()
		interaction.info = landmark
		interaction.position = landmark.pos
		add_child(interaction)
		interactions.append(interaction)
	add_collider(Rect2(0,0,3072,65))
	add_collider(Rect2(0,730,3072,38))
	add_collider(Rect2(0,0,60,768))
	add_collider(Rect2(3008,0,64,768))
	add_collider(Rect2(1090,0,30,384))
	add_collider(Rect2(1090,448,30,320))
	gate("village",Rect2(1090,384,30,64))
	add_collider(Rect2(896,0,96,384))
	add_collider(Rect2(896,448,96,320))
	rebuild_navigation()
	var rng := RandomNumberGenerator.new()
	rng.seed = 9042026
	for i in 100:
		leaves.append(Vector2(rng.randf_range(60,3000),rng.randf_range(70,720)))
	queue_redraw()

func build_expansion() -> void:
	for x in range(1190,2510,105):
		for y in [150,690]:
			if y == 690 and x >= 1580 and x <= 1840: continue
			var tree := prop(2,Vector2(x,y+(x%31)),145+float(x%23),Vector2(24,18))
			if x > 1850 and x < 2150: tree.modulate = Color("968bb9")
	for at in [Vector2(1240,295),Vector2(1390,570),Vector2(1540,300),Vector2(1700,580),Vector2(1790,330),Vector2(1980,590),Vector2(2070,480),Vector2(2390,590)]:
		var tree := prop(2,at,140,Vector2(24,18))
		if at.x > 1850 and at.x < 2140: tree.modulate = Color("968bb9")
	for x in range(1220,2450,153):
		prop(3,Vector2(x,545),85,Vector2(20,12))
	for at in [Vector2(1310,330),Vector2(1490,465),Vector2(1690,485),Vector2(1960,290),Vector2(2090,330),Vector2(2410,525)]:
		prop(8,at,45,Vector2(26,14))
	prop(11,Vector2(1490,240),68,Vector2(26,18))
	landmarks.append({"id":"memorial","pos":Vector2(1490,265),"label":"Memorial dos ausentes"})
	prop(4,Vector2(1712,644),115,Vector2(64,28))
	landmarks.append({"id":"altar","pos":Vector2(1712,674),"label":"Altar do Estandarte"})
	prop(4,Vector2(2208,375),140,Vector2(85,32))
	prop(5,Vector2(2208,440),125,Vector2.ZERO)
	landmarks.append({"id":"sanctuary","pos":Vector2(2208,414),"label":"Firmar o juramento / salvar"})
	prop(12,Vector2(1220,451),49,Vector2(14,10)).modulate = Color("b7b6a2")
	landmarks.append({"id":"survivor","pos":Vector2(1220,454),"label":"Falar com o sobrevivente"})
	for at in [Vector2(1450,260),Vector2(1755,655),Vector2(2150,415),Vector2(2270,415),Vector2(2570,375),Vector2(2570,491),Vector2(2920,280),Vector2(2920,630)]:
		prop(6,at,45,Vector2(14,12))
		lantern(at+Vector2(0,-25))
	# A fallen ridge diverts the main road north; its lower gate is the return shortcut.
	add_collider(Rect2(1856,320,32,224))
	add_collider(Rect2(1856,608,32,122))
	gate("shortcut",Rect2(1856,544,32,64))
	prop(10,Vector2(1870,567),65,Vector2.ZERO)
	landmarks.append({"id":"shortcut","pos":Vector2(1918,572),"label":"Destravar a passagem"})
	for y in range(345,720,45):
		if y > 530 and y < 620: continue
		prop(8,Vector2(1870,y),57,Vector2.ZERO)
	add_collider(Rect2(2528,65,24,287))
	add_collider(Rect2(2528,512,24,218))
	gate("arena",Rect2(2528,352,24,160))
	prop(5,Vector2(2550,421),160,Vector2.ZERO)
	prop(11,Vector2(2800,251),95,Vector2(40,28))
	for x in [2640,2730,2870,2960]:
		prop(2,Vector2(x,180),165,Vector2(26,20)).modulate = Color("a393b8")
		prop(8,Vector2(x,690),55,Vector2(30,14))
	landmarks.append({"id":"arena","pos":Vector2(2480,432),"label":"Portão do general"})
	landmarks.append({"id":"ending","pos":Vector2(2800,270),"label":"O primeiro sino"})

func gate(id: String, rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = rect.get_center()
	var c := CollisionShape2D.new()
	var s := RectangleShape2D.new()
	s.size = rect.size
	c.shape = s
	body.add_child(c)
	add_child(body)
	gates[id] = body
	gate_rects[id] = rect
	gate_closed[id] = true

func set_gate(id: String, closed: bool) -> void:
	if gate_closed[id] == closed: return
	gate_closed[id] = closed
	gates[id].set_deferred("collision_layer",1 if closed else 0)
	rebuild_navigation()
	queue_redraw()

func rebuild_navigation() -> void:
	navigation.clear()
	navigation.region = Rect2i(0,0,SIZE.x*2,SIZE.y*2)
	navigation.cell_size = Vector2(16,16)
	navigation.offset = Vector2(8,8)
	navigation.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	navigation.update()
	for y in SIZE.y*2:
		for x in SIZE.x*2:
			var p := Vector2(x*16+8,y*16+8)
			for r in blocked:
				if r.grow(8).has_point(p):
					navigation.set_point_solid(Vector2i(x,y),true)
	for id in gates:
		if not gate_closed[id]: continue
		var rect: Rect2 = gate_rects[id]
		for y in range(int(rect.position.y/16),int(rect.end.y/16)+1):
			for x in range(int(rect.position.x/16),int(rect.end.x/16)+1):
				navigation.set_point_solid(Vector2i(x,y),true)

func make_tiles() -> TileSet:
	var image := Image.create(736,128,false,Image.FORMAT_RGBA8)
	var rng := RandomNumberGenerator.new()
	rng.seed = 9042026
	var bases := [Color("344b36"),Color("867054"),Color("294c53"),Color("987344")]
	for kind in 23:
		for variant in 4:
			var origin := Vector2i(kind*32,variant*32)
			var base: Color = bases[1 if kind >= 4 else kind]
			if kind == 20: base = Color("363b43")
			if kind == 21: base = Color("645665")
			if kind == 22: base = Color("666756")
			image.fill_rect(Rect2i(origin,Vector2i(32,32)),base)
			for i in 85:
				var pos := origin + Vector2i(rng.randi_range(0,30),rng.randi_range(0,30))
				var color: Color = base.lightened(rng.randf_range(-.14,.13))
				image.fill_rect(Rect2i(pos,Vector2i(2,1)),color)
			if kind == 0:
				for i in 6:
					var pos := origin + Vector2i(rng.randi_range(1,28),rng.randi_range(3,29))
					image.set_pixelv(pos,Color("779362"))
					image.set_pixelv(pos+Vector2i(0,-1),Color("59794c"))
			if kind == 3:
				for y in range(0,32,8):
					image.fill_rect(Rect2i(origin+Vector2i(0,y),Vector2i(32,1)),Color("463b32"))
					image.fill_rect(Rect2i(origin+Vector2i(1,y+1),Vector2i(30,1)),Color("bd9761"))
			if kind == 22:
				image.fill_rect(Rect2i(origin,Vector2i(32,1)),Color("424d42"))
				image.fill_rect(Rect2i(origin+Vector2i(0,16),Vector2i(32,1)),Color("4c5748"))
				for j in 14: image.set_pixelv(origin+Vector2i(8+(j/6),j),Color("454f43"))
			if kind >= 4 and kind < 20:
				var mask := kind-4
				for py in 32:
					for px in 32:
						var edge := 3 + int(2*sin(px*.7+py*.3+variant))
						if ((mask&1) and py < edge) or ((mask&2) and px > 31-edge) or ((mask&4) and py > 31-edge) or ((mask&8) and px < edge):
							image.set_pixelv(origin+Vector2i(px,py),Color("4c6543") if (px+py)%3 == 0 else bases[0])
	var source := TileSetAtlasSource.new()
	source.texture = ImageTexture.create_from_image(image)
	source.texture_region_size = Vector2i(32,32)
	for x in 23:
		for y in 4:
			source.create_tile(Vector2i(x,y))
	var tiles := TileSet.new()
	tiles.tile_size = Vector2i(32,32)
	tiles.add_source(source,0)
	return tiles

func is_path(x: int, y: int) -> bool:
	if x < 36: return (y >= 11 and y <= 14) or (x >= 15 and x <= 17 and y > 4 and y < 21)
	if x >= 80: return y >= 8 and y <= 20
	return (x < 58 and y >= 12 and y <= 14) or (x >= 56 and x <= 65 and y >= 7 and y <= 9) or (x >= 56 and x <= 57 and y >= 9 and y <= 14) or (x >= 64 and x <= 66 and y >= 9 and y <= 13) or (x >= 65 and y >= 12 and y <= 14) or (x >= 46 and x <= 47 and y >= 8 and y <= 12) or (x >= 52 and x <= 54 and y >= 14 and y <= 21) or (x >= 54 and x <= 70 and y >= 17 and y <= 18)

func prop(index: int, at: Vector2, width: float, footprint: Vector2) -> Node2D:
	var holder := Node2D.new()
	holder.position = at
	actors.add_child(holder)
	var sprite := Sprite2D.new()
	sprite.texture = Catalog.prop_texture(index)
	var factor := width / sprite.texture.get_width()
	sprite.scale = Vector2.ONE * factor
	sprite.position.y = -sprite.texture.get_height()*factor*.46
	holder.add_child(sprite)
	if footprint != Vector2.ZERO:
		add_collider(Rect2(at-Vector2(footprint.x*.5,footprint.y*.75),footprint))
	return holder

func add_collider(rect: Rect2) -> void:
	blocked.append(rect)
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collider.shape = shape
	body.position = rect.get_center()
	body.add_child(collider)
	add_child(body)

func lantern(at: Vector2) -> void:
	if not light_texture:
		var image := Image.create(64,64,false,Image.FORMAT_RGBA8)
		for y in 64:
			for x in 64:
				var fade := maxf(0,1-Vector2(x-32,y-32).length()/32.0)
				image.set_pixel(x,y,Color(1,1,1,fade*fade))
		light_texture = ImageTexture.create_from_image(image)
	var light := PointLight2D.new()
	light.texture = light_texture
	light.color = Color("ffcc82")
	light.energy = .65
	light.texture_scale = 2.2
	light.position = at
	add_child(light)

func route(from: Vector2, to: Vector2) -> PackedVector2Array:
	var a := Vector2i(from / 16)
	var b := Vector2i(to / 16)
	if not navigation.is_in_boundsv(a) or not navigation.is_in_boundsv(b):
		return PackedVector2Array()
	a = nearest_free(a,from)
	b = nearest_free(b,to)
	if navigation.is_point_solid(a) or navigation.is_point_solid(b): return PackedVector2Array()
	return navigation.get_point_path(a,b)

func nearest_free(cell: Vector2i, point: Vector2) -> Vector2i:
	if not navigation.is_point_solid(cell): return cell
	var nearest := cell
	var distance := INF
	for y in range(cell.y-3,cell.y+4):
		for x in range(cell.x-3,cell.x+4):
			var candidate := Vector2i(x,y)
			if not navigation.is_in_boundsv(candidate) or navigation.is_point_solid(candidate): continue
			var d := point.distance_squared_to(Vector2(candidate)*16+Vector2(8,8))
			if d < distance:
				distance = d
				nearest = candidate
	return nearest

func _process(dt: float) -> void:
	world_time += dt
	clock += dt
	if clock > .12:
		clock = 0
		queue_redraw()

func _draw() -> void:
	draw_arc(Vector2(2816,432),123,0,TAU,96,Color("9d9870"),2)
	draw_arc(Vector2(2816,432),128,0,TAU,96,Color("4c5748"),1)
	for i in 8:
		var at := Vector2(2816,432)+Vector2.from_angle(i*TAU/8)*119
		draw_line(at,at+Vector2.from_angle(i*TAU/8)*8,Color("b9a36b"),2)
	for id in gates:
		if gate_closed[id]:
			var r: Rect2 = gate_rects[id]
			draw_rect(r,Color(.28,.16,.34,.26))
			for y in range(int(r.position.y),int(r.end.y),10):
				draw_line(Vector2(r.position.x,y),Vector2(r.end.x,y+4),Color("a4879b"),2)
	for i in 65:
		var at := Vector2(1900+(i*71)%224,155+(i*97)%540)
		draw_line(at,at+Vector2(8,-4),Color("66557b"),1)
	# Water highlights remain on the logical pixel grid.
	for y in range(76,725,17):
		if y >= 384 and y < 448:
			continue
		var shift := int(world_time*9 + y) % 57
		draw_rect(Rect2(906+shift,y,19,1),Color("5b7f77"))
		draw_rect(Rect2(904,y,2,8),Color("637d65"))
		draw_rect(Rect2(988,y,2,8),Color("637d65"))
	for i in leaves.size():
		var base := leaves[i]
		var at := base + Vector2(sin(world_time*.5+i)*18, fmod(world_time*8+i*9,75))
		draw_rect(Rect2(at.round(),Vector2(3,1)),Color("bea563"))
