class_name AmaharaUI
extends CanvasLayer

const INK := Color("12221f")
const PAPER := Color("eddfba")
const GOLD := Color("d6ae63")
var game
var root: Control
var menu: Control
var hud: Control
var dialog: Control
var toast_label: Label
var health: ProgressBar
var energy: ProgressBar
var status: Label
var objective: Label
var prompt: Label
var cooldowns: Label
var speaker: Label
var speech: Label
var modal: Control
var fade: ColorRect
var menu_buttons: Array[Button] = []
var region_label: Label
var boss_health: ProgressBar
var boss_posture: ProgressBar
var boss_title: Label

func _ready() -> void:
	layer = 20
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = make_theme()
	add_child(root)
	build_menu()
	build_hud()
	build_dialogue()
	toast_label = label(root,"",Vector2(90,68),Vector2(460,30),12,GOLD)
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.add_theme_color_override("font_shadow_color",Color.BLACK)
	toast_label.add_theme_constant_override("shadow_offset_x",1)
	toast_label.add_theme_constant_override("shadow_offset_y",1)
	toast_label.hide()
	fade = ColorRect.new()
	fade.color = Color(0,0,0,0)
	fade.size = Vector2(640,360)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(fade)

func make_theme() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = 13
	for state_name in ["normal","hover","pressed","focus","disabled"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color("294337") if state_name in ["hover","focus"] else Color("14251f")
		box.border_color = GOLD if state_name in ["hover","focus"] else Color("52604a")
		box.set_border_width_all(1)
		box.content_margin_left = 12
		box.content_margin_right = 12
		box.content_margin_top = 7
		box.content_margin_bottom = 7
		theme.set_stylebox(state_name,"Button",box)
	theme.set_color("font_color","Button",PAPER)
	theme.set_color("font_focus_color","Button",Color("ffe7aa"))
	theme.set_color("font_disabled_color","Button",Color("738073"))
	return theme

func panel(parent: Node, at: Vector2, size: Vector2, color: Color = INK) -> Panel:
	var p := Panel.new()
	p.position = at
	p.size = size
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = Color("697352")
	box.set_border_width_all(1)
	p.add_theme_stylebox_override("panel",box)
	parent.add_child(p)
	return p

func label(parent: Node, text: String, at: Vector2, size: Vector2, font_size: int = 13, color: Color = PAPER) -> Label:
	var l := Label.new()
	l.text = text
	l.position = at
	l.size = size
	l.add_theme_font_size_override("font_size",font_size)
	l.add_theme_color_override("font_color",color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(l)
	return l

func button(parent: Node, text: String, at: Vector2, size: Vector2, callback: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.position = at
	b.size = size
	b.pressed.connect(func(): game.audio.sfx("ui"); callback.call())
	parent.add_child(b)
	return b

func build_menu() -> void:
	menu = Control.new()
	menu.size = Vector2(640,360)
	root.add_child(menu)
	var bg := Sprite2D.new()
	bg.texture = load("res://assets/title.png")
	bg.centered = false
	bg.scale = Vector2(640,360)/bg.texture.get_size()
	menu.add_child(bg)
	var veil := ColorRect.new()
	veil.color = Color(.025,.06,.055,.62)
	veil.size = Vector2(320,360)
	menu.add_child(veil)
	label(menu,"UM JURAMENTO RESISTE AO SILÊNCIO",Vector2(32,32),Vector2(310,22),10,GOLD)
	var title := label(menu,"AMAHARA",Vector2(28,57),Vector2(310,70),46,PAPER)
	var serif := SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Times New Roman"])
	title.add_theme_font_override("font",serif)
	label(menu,"J U R A M E N T O  D E  G U E R R A",Vector2(34,116),Vector2(310,24),11,GOLD)
	label(menu,"O sino tocou. Os mortos escutaram.",Vector2(34,151),Vector2(300,22),12,Color("bdc7ae"))
	menu_buttons.append(button(menu,"ENTRAR EM AMAHARA",Vector2(34,190),Vector2(236,33),func(): game.start_sample()))
	menu_buttons.append(button(menu,"CONTINUAR",Vector2(34,230),Vector2(113,29),func(): game.start_sample(true)))
	menu_buttons.append(button(menu,"CONTROLES",Vector2(154,230),Vector2(116,29),show_controls))
	menu_buttons.append(button(menu,"OPÇÕES",Vector2(34,266),Vector2(113,29),show_options))
	menu_buttons.append(button(menu,"SAIR",Vector2(154,266),Vector2(116,29),func(): game.close_game()))
	label(menu,"FASE 1  /  O PRIMEIRO SINO",Vector2(34,325),Vector2(370,20),10,Color("bdc7ae"))
	menu_buttons[1].disabled = SaveStore.read_save().is_empty()
	menu_buttons[0].grab_focus()

func build_hud() -> void:
	hud = Control.new()
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(hud)
	panel(hud,Vector2(12,12),Vector2(185,53),Color(.055,.10,.085,.94))
	label(hud,"REN KUROGANE",Vector2(22,17),Vector2(170,16),11,GOLD)
	health = bar(Vector2(22,37),Vector2(118,6),Color("b76757"))
	energy = bar(Vector2(22,49),Vector2(118,5),Color("7db9a6"))
	status = label(hud,"100 / 100",Vector2(145,31),Vector2(47,30),9,PAPER)
	objective = label(hud,"",Vector2(326,17),Vector2(301,42),12,PAPER)
	objective.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	region_label = label(hud,"AMAHARA",Vector2(12,332),Vector2(265,16),10,GOLD)
	boss_title = label(hud,"GENERAL JINZŌ",Vector2(200,274),Vector2(240,18),11,GOLD)
	boss_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boss_health = bar(Vector2(205,295),Vector2(230,5),Color("ae6269"))
	boss_posture = bar(Vector2(205,304),Vector2(230,3),GOLD)
	cooldowns = label(hud,"",Vector2(285,331),Vector2(340,20),10,PAPER)
	cooldowns.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prompt = label(hud,"",Vector2(160,294),Vector2(320,22),12,PAPER)
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.add_theme_color_override("font_shadow_color",Color.BLACK)
	prompt.add_theme_constant_override("shadow_offset_y",2)
	hud.hide()

func bar(at: Vector2, size: Vector2, color: Color) -> ProgressBar:
	var b := ProgressBar.new()
	b.position = at
	b.size = size
	b.show_percentage = false
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var background := StyleBoxFlat.new()
	background.bg_color = Color("263a32")
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	b.add_theme_stylebox_override("background",background)
	b.add_theme_stylebox_override("fill",fill)
	hud.add_child(b)
	b.size = size
	return b

func build_dialogue() -> void:
	dialog = panel(root,Vector2(48,245),Vector2(544,99),Color(.06,.10,.08,.98))
	speaker = label(dialog,"YUNA",Vector2(16,9),Vector2(510,20),12,GOLD)
	speech = label(dialog,"",Vector2(16,33),Vector2(510,42),13,PAPER)
	speech.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label(dialog,"F / ×  CONTINUAR",Vector2(390,76),Vector2(145,20),10,GOLD)
	dialog.hide()

func refresh() -> void:
	if not game.player: return
	health.value = game.player.hp/game.player.max_hp*100
	energy.value = game.player.energy/game.player.max_energy*100
	status.text = "%d / %d\n%d DIV" % [ceili(game.player.hp),game.player.max_hp,int(game.player.energy)]
	objective.text = game.objective
	region_label.text = game.region
	var show_boss: bool = game.boss_active and is_instance_valid(game.boss)
	boss_health.visible = show_boss
	boss_posture.visible = show_boss
	boss_title.visible = show_boss
	if show_boss:
		boss_health.value = game.boss.hp/game.boss.max_hp*100
		boss_posture.value = 100-game.boss.posture
		boss_title.text = "JINZŌ  /  " + ("O JURAMENTO" if game.boss.phase == 1 else "O CHAMADO")
	var cd: Array[float] = game.player.cast_cd
	var one := "PRONTO" if cd[0] <= 0 else "%.1fs" % cd[0]
	var two := "PRONTO" if cd[1] <= 0 else "%.1fs" % cd[1]
	var pad := not Input.get_connected_joypads().is_empty()
	cooldowns.text = "%s CORTE %s    %s SELO %s" % ["L1" if pad else "Q",one,"R1" if pad else "E",two]
	prompt.text = ("×  " if pad else "F  ") + game.interaction_label() if not game.interaction_label().is_empty() else ""
	prompt.visible = not dialog.visible

func clear_modal() -> void:
	if is_instance_valid(modal):
		modal.queue_free()
	modal = null

func modal_panel(title: String) -> Panel:
	clear_modal()
	modal = Control.new()
	modal.size = Vector2(640,360)
	root.add_child(modal)
	var veil := ColorRect.new()
	veil.color = Color(0.02,.04,.035,.83)
	veil.size = Vector2(640,360)
	modal.add_child(veil)
	var p := panel(modal,Vector2(126,35),Vector2(388,289))
	label(p,title,Vector2(24,18),Vector2(340,29),23,GOLD)
	return p

func show_controls() -> void:
	var p := modal_panel("A ARTE DA KATANA")
	label(p,"Mover\nLeve\nPesado\nEsquiva\nCorte\nSelo\nInteragir\nPausar",Vector2(24,64),Vector2(80,160),12,PAPER)
	label(p,"WASD / Setas\nJ\nK\nEspaço\nQ\nE\nF\nEsc",Vector2(115,64),Vector2(110,160),12,PAPER)
	label(p,"Analógico / D-pad\nQuadrado\nTriângulo\nCírculo\nL1\nR1\nX\nOptions",Vector2(234,64),Vector2(140,160),12,PAPER)
	label(p,"Repita o botão no fim do golpe para encadear.",Vector2(24,217),Vector2(345,21),11,GOLD)
	button(p,"VOLTAR",Vector2(24,248),Vector2(340,29),return_from_modal).grab_focus()

func return_from_modal() -> void:
	clear_modal()
	if game.running:
		show_pause()
	else:
		menu_buttons[0].grab_focus()

func show_pause() -> void:
	var p := modal_panel("JURAMENTO EM SUSPENSO")
	button(p,"CONTINUAR",Vector2(24,64),Vector2(340,32),func(): clear_modal(); game.set_paused(false)).grab_focus()
	button(p,"CONTROLES",Vector2(24,104),Vector2(340,32),show_controls)
	button(p,"OPÇÕES",Vector2(24,144),Vector2(340,32),show_options)
	button(p,"VOLTAR AO CHECKPOINT",Vector2(24,184),Vector2(340,32),func(): clear_modal(); game.respawn())
	button(p,"MENU",Vector2(24,224),Vector2(340,32),func(): clear_modal(); game.return_menu())

func show_options() -> void:
	var p := modal_panel("SOM E APRESENTAÇÃO")
	label(p,"Música",Vector2(24,66),Vector2(310,20))
	var music := HSlider.new()
	music.position = Vector2(24,94)
	music.size = Vector2(340,20)
	music.value = game.audio.music_volume*100
	p.add_child(music)
	music.value_changed.connect(func(v): game.audio.set_music_volume(v/100); game.persist_settings())
	label(p,"Efeitos",Vector2(24,130),Vector2(310,20))
	var sound := HSlider.new()
	sound.position = Vector2(24,158)
	sound.size = Vector2(340,20)
	sound.value = game.audio.sfx_volume*100
	p.add_child(sound)
	sound.value_changed.connect(func(v): game.audio.sfx_volume=v/100; game.persist_settings())
	button(p,"TELA CHEIA / JANELA",Vector2(24,199),Vector2(210,29),func(): game.toggle_fullscreen())
	var vibrate := CheckButton.new()
	vibrate.text = "Vibrar"
	vibrate.position = Vector2(245,199)
	vibrate.button_pressed = game.vibration
	p.add_child(vibrate)
	vibrate.toggled.connect(func(value): game.vibration=value; game.persist_settings())
	button(p,"VOLTAR",Vector2(24,241),Vector2(340,29),return_from_modal)
	music.grab_focus()

func show_victory() -> void:
	game.set_paused(true)
	var p := modal_panel("O PRIMEIRO SINO")
	label(p,"FASE 1 CONCLUÍDA",Vector2(24,66),Vector2(340,24),18,GOLD)
	label(p,"Amahara está segura por esta noite.\nSegredos encontrados: %d / 2\nRetornos ao santuário: %d" % [game.story.upgrades.size(),game.deaths],Vector2(24,110),Vector2(340,80),13,PAPER)
	button(p,"EXPLORAR AMAHARA",Vector2(24,205),Vector2(340,30),func(): clear_modal(); game.set_paused(false)).grab_focus()
	button(p,"VOLTAR AO MENU",Vector2(24,245),Vector2(340,30),func(): game.return_menu())
