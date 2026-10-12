extends Node2D

var checkpoint := Vector2(140, 420)
var fragments := 0
var respawning := false
var elapsed_time := 0.0
var deaths := 0
const PAR_TIME := 65.0

@onready var player: CharacterBody2D = $Player
@onready var fragment_counter: Label = $HUD/FragmentCounter
@onready var alert_message: Label = $HUD/AlertMessage

func _ready() -> void:
	update_fragment_counter()

func _process(_delta: float) -> void:
	elapsed_time += _delta
	if player.position.x > 1550.0 and checkpoint.x < 1550.0:
		checkpoint = Vector2(1575, 420)
		AudioManager.play_sfx("checkpoint")

	if player.position.y > 720.0:
		respawn_player("The storm swallowed you.")

func collect_fragment() -> void:
	fragments += 1
	update_fragment_counter()

func update_fragment_counter() -> void:
	fragment_counter.text = "STORM %d / 3   ◆ %d" % [fragments, GameState.shadow_shards]

func respawn_player(message: String = "The storm found you.") -> void:
	if respawning:
		return
	respawning = true
	deaths += 1
	AudioManager.play_sfx("alert")
	alert_message.text = message
	alert_message.visible = true
	player.position = checkpoint
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(0.75).timeout
	alert_message.visible = false
	respawning = false


func get_run_summary() -> Dictionary:
	var grade := GameState.calculate_grade(elapsed_time, deaths, fragments, PAR_TIME)
	return {
		"grade": grade,
		"time": elapsed_time,
		"deaths": deaths,
		"fragments": fragments
	}
