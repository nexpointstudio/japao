class_name AttackData
extends Resource

@export var id: String = ""
@export var title: String = ""
@export var damage: float = 12.0
@export var startup: float = 0.08
@export var active: float = 0.12
@export var recovery: float = 0.18
@export var reach: float = 23.0
@export var size: Vector2 = Vector2(32, 25)
@export var knockback: float = 70.0
@export var stagger: float = 12.0
@export var step_speed: float = 35.0
@export var energy_gain: float = 6.0
@export var hitstop: float = 0.035
@export var animation: String = "attack"
@export var next_light: String = ""
@export var next_heavy: String = ""
@export var buffer_window: float = 0.25
@export var cancel_time: float = 0.25

func duration() -> float:
	return startup + active + recovery
