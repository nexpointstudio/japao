class_name StoryProgression
extends RefCounted

signal changed(stage: int)
signal collected(id: String)
signal checkpoint_changed(id: String)
var stage: int = 0
var checkpoint := "village"
var upgrades: Array = []
var completed: Array = []
var shortcut := false

func advance(value: int) -> void:
	if value > stage:
		stage = value
		changed.emit(stage)

func collect(id: String) -> bool:
	if id in upgrades: return false
	upgrades.append(id)
	collected.emit(id)
	return true

func checkpoint_position() -> Vector2:
	return Vector2(2208,424) if checkpoint == "sanctuary" else Vector2(512,416)

func objective() -> String:
	return ["Defenda a praça ao sul.","Volte e converse com Yuna.","Siga a estrada para leste. Encontre o santuário.","Descanse no santuário. F / ×", "Derrote a guarda de elite a leste.","Entre pelo torii. Enfrente Jinzō.","O primeiro sino silenciou. Explore Amahara."][stage]

func snapshot() -> Dictionary:
	return {"stage":stage,"checkpoint":checkpoint,"upgrades":upgrades.duplicate(),"completed":completed.duplicate(),"shortcut":shortcut}

func restore(data: Dictionary) -> void:
	stage = int(data.get("stage",0))
	checkpoint = data.get("checkpoint","village")
	upgrades = data.get("upgrades",[]).duplicate()
	completed = data.get("completed",[]).duplicate()
	shortcut = data.get("shortcut",false)
