extends Area2D

@export var destination := Vector2.ZERO
@export var launch_velocity := Vector2(300, -180)

var cooldown := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	rotation += 0.008

func _on_body_entered(body: Node) -> void:
	if cooldown or not body is CharacterBody2D:
		return
	if not bool(body.get("is_shadow")):
		return

	cooldown = true
	body.global_position = destination
	body.velocity = launch_velocity
	await get_tree().create_timer(0.35).timeout
	cooldown = false
