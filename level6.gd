extends Node2D

var checkpoint := Vector2(140, 420)
var fragments := 0
var respawning := false
var elapsed_time := 0.0
var deaths := 0
var decoy_triggered := false
const PAR_TIME := 110.0

@onready var player: CharacterBody2D = $Player
@onready var counter: Label = $HUD/FragmentCounter
@onready var alert: Label = $HUD/AlertMessage
@onready var mission: Label = $HUD/Mission

func _ready() -> void:
	update_counter()
	$HunterDecoy.visible = false
	$HunterDecoy.set_process(false)
	$HunterDecoy.monitoring = false

func _process(delta: float) -> void:
	elapsed_time += delta

	if player.position.x > 1450.0 and checkpoint.x < 1450.0:
		checkpoint = Vector2(1480, 420)
		AudioManager.play_sfx("checkpoint")
		FXManager.checkpoint_burst(checkpoint)

	if player.position.x > 3000.0 and checkpoint.x < 3000.0:
		checkpoint = Vector2(3020, 420)
		AudioManager.play_sfx("checkpoint")
		FXManager.checkpoint_burst(checkpoint)

	if player.position.y > 720.0:
		respawn_player("THE ARCHIVE ERASED YOUR TRACE.")

func collect_fragment() -> void:
	fragments += 1
	update_counter()

func update_counter() -> void:
	counter.text = "ARCHIVE %d / 3   ◆ %d" % [fragments, GameState.shadow_shards]

func trigger_decoy(_position: Vector2, message: String) -> void:
	if decoy_triggered:
		return
	decoy_triggered = true
	alert.text = message
	alert.visible = true
	$HunterDecoy.visible = true
	$HunterDecoy.set_process(true)
	$HunterDecoy.monitoring = true
	await get_tree().create_timer(1.1).timeout
	alert.visible = false

func show_memory(memory_id: String, text_value: String) -> void:
	mission.text = "%s RECOVERED — %s" % [memory_id, text_value]
	await get_tree().create_timer(2.4).timeout
	mission.text = "OPTIONAL: recover hidden memories • beat your best time"

func respawn_player(message: String = "ARCHIVE SECURITY TRIGGERED.") -> void:
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
