class_name AmaharaAudio
extends Node

var music: AudioStreamPlayer
var voices: Array[AudioStreamPlayer] = []
var streams: Dictionary = {}
var voice_index: int = 0
var music_volume: float = .55
var sfx_volume: float = .65
var current_track := "village"
var stopping := false

func _ready() -> void:
	for id in ["slash","heavy","hit","hurt","dash","magic1","magic2","perfect","warn","ui","shrine"]:
		streams[id] = load("res://assets/audio/"+id+".wav")
	music = AudioStreamPlayer.new()
	music.stream = load("res://assets/audio/village.wav")
	add_child(music)
	music.finished.connect(func():
		if not stopping: music.play())
	music.volume_db = linear_to_db(music_volume)
	music.play()
	for i in 8:
		var voice := AudioStreamPlayer.new()
		add_child(voice)
		voices.append(voice)

func sfx(id: String) -> void:
	if stopping or not streams.has(id): return
	var voice := voices[voice_index]
	voice_index = (voice_index+1)%voices.size()
	voice.stream = streams[id]
	voice.volume_db = linear_to_db(maxf(.001,sfx_volume))
	voice.play()

func set_music_volume(value: float) -> void:
	music_volume = value
	music.volume_db = linear_to_db(maxf(.001,value))

func shutdown() -> void:
	stopping = true
	music.stop()
	music.stream = null
	music.queue_free()
	for voice in voices:
		voice.stop()
		voice.stream = null
		voice.queue_free()
	streams.clear()

func change_track(id: String) -> void:
	if stopping or id == current_track: return
	current_track = id
	music.stop()
	music.stream = load("res://assets/audio/"+id+".wav")
	music.play()
