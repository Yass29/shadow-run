extends Node2D

var checkpoint := Vector2(140, 420)
var fragments := 0
var respawning := false
var elapsed_time := 0.0
var deaths := 0
const PAR_TIME := 90.0

@onready var player: CharacterBody2D = $Player
@onready var counter: Label = $HUD/FragmentCounter
@onready var alert: Label = $HUD/AlertMessage

func _ready() -> void:
	update_counter()

func _process(_delta: float) -> void:
	elapsed_time += _delta
	if player.position.x > 1900.0 and checkpoint.x < 1900.0:
		checkpoint = Vector2(1930, 420)
		AudioManager.play_sfx("checkpoint")
	if player.position.y > 720.0:
		respawn_player("THE CORE REJECTED YOU.")

func collect_fragment() -> void:
	fragments += 1
	update_counter()

func update_counter() -> void:
	counter.text = "CORE %d / 3   ◆ %d" % [fragments, GameState.shadow_shards]

func respawn_player(message: String = "CORE DEFENSE TRIGGERED.") -> void:
	if respawning:
		return
	respawning = true
	deaths += 1
	AudioManager.play_sfx("alert")
	alert.text = message
	alert.visible = true
	player.position = checkpoint
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(0.75).timeout
	alert.visible = false
	respawning = false


func get_run_summary() -> Dictionary:
	var grade := GameState.calculate_grade(elapsed_time, deaths, fragments, PAR_TIME)
	return {
		"grade": grade,
		"time": elapsed_time,
		"deaths": deaths,
		"fragments": fragments
	}
