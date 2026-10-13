extends Area2D

@export var activation_distance := 520.0
@export var chase_speed := 170.0
@export var return_speed := 90.0
@export var search_duration := 2.4

var home := Vector2.ZERO
var time := 0.0
var cooldown := 0.0
var searching := false
var search_timer := 0.0
var last_seen_position := Vector2.ZERO
var was_hunting := false

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
	var visible_target := distance < activation_distance and not bool(target.get("is_shadow"))

	if visible_target:
		was_hunting = true
		searching = false
		last_seen_position = target.global_position
		move_toward_point(last_seen_position, chase_speed, delta)
	elif was_hunting:
		was_hunting = false
		searching = true
		search_timer = search_duration
	elif searching:
		search_timer -= delta
		move_toward_point(last_seen_position, chase_speed * 0.72, delta)
		rotation = sin(time * 10.0) * 0.14
		if search_timer <= 0.0 or global_position.distance_to(last_seen_position) < 12.0:
			searching = false
	else:
		global_position = global_position.move_toward(home, return_speed * delta)
		rotation = sin(time * 5.0) * 0.05

func move_toward_point(point: Vector2, speed: float, delta: float) -> void:
	var direction := (point - global_position).normalized()
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if cooldown > 0.0 or not body is CharacterBody2D:
		return
	cooldown = 1.0
	searching = false
	was_hunting = false
	var level := get_parent()
	if level.has_method("respawn_player"):
		level.respawn_player("HUNTER CAUGHT YOU — disappear into shadow.")
	position = home
