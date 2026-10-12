extends Area2D

@export var activation_distance := 520.0
@export var chase_speed := 170.0
@export var return_speed := 90.0

var home := Vector2.ZERO
var time := 0.0
var cooldown := 0.0
@onready var target: CharacterBody2D = get_parent().get_node("Player")

func _ready() -> void:
	home = position
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	time += delta
	cooldown = max(cooldown - delta, 0.0)

	if target == null:
		return

	var distance := global_position.distance_to(target.global_position)
	var hunting := distance < activation_distance and not bool(target.get("is_shadow"))

	if hunting:
		var direction := (target.global_position - global_position).normalized()
		global_position += direction * chase_speed * delta
	else:
		global_position = global_position.move_toward(home, return_speed * delta)

	rotation = sin(time * 5.0) * 0.05

func _on_body_entered(body: Node) -> void:
	if cooldown > 0.0 or not body is CharacterBody2D:
		return
	cooldown = 1.0
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player("HUNTER CAUGHT YOU — disappear into shadow.")
	position = home
