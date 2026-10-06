class_name BattleFX
extends Node2D

var motes: Array[Dictionary] = []
var arcs: Array[Dictionary] = []
var labels: Array[Dictionary] = []
var clock: float = 0.0

func _ready() -> void:
	z_index = 10

func burst(at: Vector2, color: Color, count: int = 10, speed: float = 65.0) -> void:
	for i in count:
		var direction := Vector2.from_angle(randf() * TAU)
		motes.append({"p": at, "v": direction * randf_range(speed * 0.3, speed), "life": randf_range(.2, .5), "color": color})

func slash(at: Vector2, dir: Vector2, heavy: bool, reverse: bool = false) -> void:
	arcs.append({"p": at + Vector2(0,-11), "angle": dir.angle(), "life": .16, "max": .16, "radius": 39.0 if heavy else 32.0, "color": Color("f5c577") if heavy else Color("edf9d7"), "reverse": reverse, "ring": false})

func ring(at: Vector2, radius: float, color: Color, duration: float = .4) -> void:
	arcs.append({"p": at, "angle": 0.0, "life": duration, "max": duration, "radius": radius, "color": color, "ring": true, "reverse": false})

func word(at: Vector2, value: String, color: Color) -> void:
	var offset := Vector2(-12,-42)
	if value.length() > 4:
		offset = Vector2(-45,-61)
	labels.append({"p": at + offset, "life": .85, "text": value, "color": color})

func _process(dt: float) -> void:
	clock += dt
	for mote in motes:
		mote.life -= dt
		mote.p += mote.v * dt
		mote.v *= pow(.1, dt)
	motes = motes.filter(func(m): return m.life > 0)
	for arc in arcs:
		arc.life -= dt
	arcs = arcs.filter(func(a): return a.life > 0)
	for label in labels:
		label.life -= dt
		label.p.y -= dt * 16
	labels = labels.filter(func(l): return l.life > 0)
	queue_redraw()

func _draw() -> void:
	for mote in motes:
		var color: Color = mote.color
		color.a = minf(1.0, mote.life * 4)
		draw_rect(Rect2(mote.p.round(), Vector2(2,2)), color)
	for arc in arcs:
		var color: Color = arc.color
		color.a = arc.life / arc.max
		var radius: float = arc.radius
		if arc.ring:
			radius *= .3 + .7 * (1 - arc.life / arc.max)
			draw_arc(arc.p, radius, 0, TAU, 48, color, 2, false)
		else:
			var angle: float = arc.angle
			draw_arc(arc.p, radius, angle - .95, angle + .95, 16, color, 3, false)
			draw_arc(arc.p, radius - 5, angle - .7, angle + .7, 14, Color(color, color.a * .4), 2, false)
	for label in labels:
		var color: Color = label.color
		color.a = minf(1.0, label.life * 3)
		draw_string(ThemeDB.fallback_font, label.p + Vector2(1,1), label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0,0,0,color.a))
		draw_string(ThemeDB.fallback_font, label.p, label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, color)
