extends Area2D

@export var cycle_speed := 2.0
var time := 0.0
var active := true

@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	active = sin(time * cycle_speed) > -0.2
	visual.modulate.a = 0.72 if active else 0.12

func _on_body_entered(body: Node) -> void:
	if not active or not body is CharacterBody2D:
		return

	if bool(body.get("is_shadow")):
		return

	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player("LIGHT BURN — use your shadow.")
