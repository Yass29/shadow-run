extends Node

const SAVE_PATH := "user://shadow_run.cfg"

var selected_skin := "shade"
var shadow_shards := 0
var max_unlocked_level := 1
var best_grades := {}
var best_times := {}
var unlocked_memories := {}
var s_rank_rewards := {}
var intro_seen := false
var ending_seen := false
var unlocked_skins := {
	"shade": true,
	"neon": true
}
var premium_wraith_owned := false
var premium_specter_owned := false
var memory_master_reward_claimed := false
var shard_combo_count := 0
var shard_combo_timer := 0.0

const SKIN_ORDER := ["shade", "neon", "ember", "frost", "void", "echo", "wraith", "specter"]

const SKINS := {
	"shade": {
		"name": "SHADE",
		"premium": false,
		"cost": 0,
		"price": "",
		"torso": Color(0.20, 0.22, 0.36, 1.0),
		"cape": Color(0.16, 0.09, 0.30, 1.0),
		"head": Color(0.10, 0.11, 0.20, 1.0),
		"eyes": Color(0.55, 0.88, 1.0, 1.0),
		"scarf": Color(0.56, 0.31, 0.92, 1.0),
		"core": Color(0.48, 0.80, 1.0, 1.0)
	},
	"neon": {
		"name": "NEON",
		"premium": false,
		"cost": 0,
		"price": "",
		"torso": Color(0.08, 0.24, 0.30, 1.0),
		"cape": Color(0.04, 0.12, 0.17, 1.0),
		"head": Color(0.04, 0.09, 0.12, 1.0),
		"eyes": Color(0.35, 1.0, 0.82, 1.0),
		"scarf": Color(0.18, 0.90, 0.76, 1.0),
		"core": Color(0.42, 1.0, 0.86, 1.0)
	},
	"ember": {
		"name": "EMBER",
		"premium": false,
		"cost": 4,
		"price": "",
		"torso": Color(0.30, 0.10, 0.07, 1.0),
		"cape": Color(0.18, 0.04, 0.025, 1.0),
		"head": Color(0.10, 0.035, 0.02, 1.0),
		"eyes": Color(1.0, 0.65, 0.24, 1.0),
		"scarf": Color(1.0, 0.28, 0.12, 1.0),
		"core": Color(1.0, 0.78, 0.30, 1.0)
	},
	"frost": {
		"name": "FROST",
		"premium": false,
		"cost": 8,
		"price": "",
		"torso": Color(0.10, 0.20, 0.32, 1.0),
		"cape": Color(0.04, 0.10, 0.18, 1.0),
		"head": Color(0.05, 0.11, 0.20, 1.0),
		"eyes": Color(0.72, 0.95, 1.0, 1.0),
		"scarf": Color(0.42, 0.80, 1.0, 1.0),
		"core": Color(0.72, 0.95, 1.0, 1.0)
	},
	"void": {
		"name": "VOID",
		"premium": false,
		"cost": 12,
		"price": "",
		"torso": Color(0.17, 0.09, 0.24, 1.0),
		"cape": Color(0.06, 0.025, 0.11, 1.0),
		"head": Color(0.045, 0.02, 0.08, 1.0),
		"eyes": Color(0.92, 0.40, 1.0, 1.0),
		"scarf": Color(0.60, 0.20, 0.86, 1.0),
		"core": Color(0.95, 0.42, 1.0, 1.0)
	},
	"echo": {
		"name": "ECHO",
		"premium": false,
		"memory_reward": true,
		"cost": 0,
		"price": "",
		"torso": Color(0.10, 0.24, 0.26, 1.0),
		"cape": Color(0.05, 0.10, 0.16, 1.0),
		"head": Color(0.035, 0.08, 0.12, 1.0),
		"eyes": Color(0.78, 1.0, 0.92, 1.0),
		"scarf": Color(0.38, 1.0, 0.80, 1.0),
		"core": Color(0.72, 1.0, 0.94, 1.0)
	},
	"wraith": {
		"name": "WRAITH",
		"premium": true,
		"cost": 0,
		"price": "$2.99",
		"torso": Color(0.27, 0.07, 0.10, 1.0),
		"cape": Color(0.16, 0.025, 0.04, 1.0),
		"head": Color(0.09, 0.025, 0.03, 1.0),
		"eyes": Color(1.0, 0.30, 0.30, 1.0),
		"scarf": Color(0.95, 0.16, 0.22, 1.0),
		"core": Color(1.0, 0.45, 0.35, 1.0)
	},
	"specter": {
		"name": "SPECTER",
		"premium": true,
		"cost": 0,
		"price": "$4.99",
		"torso": Color(0.20, 0.16, 0.33, 1.0),
		"cape": Color(0.10, 0.06, 0.20, 1.0),
		"head": Color(0.07, 0.05, 0.12, 1.0),
		"eyes": Color(0.95, 0.82, 1.0, 1.0),
		"scarf": Color(0.76, 0.48, 1.0, 1.0),
		"core": Color(0.95, 0.78, 1.0, 1.0)
	}
}

func _ready() -> void:
	load_progress()

func _process(delta: float) -> void:
	shard_combo_timer = max(shard_combo_timer - delta, 0.0)
	if shard_combo_timer <= 0.0:
		shard_combo_count = 0

func is_owned(skin_id: String) -> bool:
	if skin_id == "wraith":
		return premium_wraith_owned
	if skin_id == "specter":
		return premium_specter_owned
	return bool(unlocked_skins.get(skin_id, false))

func select_skin(skin_id: String) -> bool:
	if not SKINS.has(skin_id) or not is_owned(skin_id):
		return false
	selected_skin = skin_id
	save_progress()
	return true

func purchase_skin(skin_id: String) -> bool:
	if not SKINS.has(skin_id):
		return false
	var skin = SKINS[skin_id]
	if bool(skin["premium"]):
		return false
	if bool(skin.get("memory_reward", false)):
		return false
	if is_owned(skin_id):
		return true
	var cost := int(skin["cost"])
	if shadow_shards < cost:
		return false
	shadow_shards -= cost
	unlocked_skins[skin_id] = true
	save_progress()
	return true

func collect_combo_shard() -> Dictionary:
	if shard_combo_timer > 0.0:
		shard_combo_count += 1
	else:
		shard_combo_count = 1
	shard_combo_timer = 2.4
	var bonus := mini(2, int((shard_combo_count - 1) / 3))
	var reward := 1 + bonus
	add_shards(reward)
	return {"reward": reward, "combo": shard_combo_count}

func add_shards(amount: int) -> void:
	shadow_shards += max(amount, 0)
	save_progress()

func unlock_level(level_number: int) -> void:
	max_unlocked_level = max(max_unlocked_level, level_number)
	save_progress()

func save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "selected_skin", selected_skin)
	config.set_value("progress", "shadow_shards", shadow_shards)
	config.set_value("progress", "max_unlocked_level", max_unlocked_level)
	config.set_value("progress", "best_grades", best_grades)
	config.set_value("progress", "best_times", best_times)
	config.set_value("progress", "unlocked_memories", unlocked_memories)
	config.set_value("progress", "s_rank_rewards", s_rank_rewards)
	config.set_value("progress", "intro_seen", intro_seen)
	config.set_value("progress", "ending_seen", ending_seen)
	config.set_value("progress", "unlocked_skins", unlocked_skins)
	config.set_value("progress", "premium_wraith_owned", premium_wraith_owned)
	config.set_value("progress", "premium_specter_owned", premium_specter_owned)
	config.set_value("progress", "memory_master_reward_claimed", memory_master_reward_claimed)
	config.save(SAVE_PATH)

func load_progress() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	selected_skin = str(config.get_value("progress", "selected_skin", "shade"))
	shadow_shards = int(config.get_value("progress", "shadow_shards", 0))
	max_unlocked_level = int(config.get_value("progress", "max_unlocked_level", 1))
	best_grades = config.get_value("progress", "best_grades", {})
	best_times = config.get_value("progress", "best_times", {})
	unlocked_memories = config.get_value("progress", "unlocked_memories", {})
	s_rank_rewards = config.get_value("progress", "s_rank_rewards", {})
	intro_seen = bool(config.get_value("progress", "intro_seen", false))
	ending_seen = bool(config.get_value("progress", "ending_seen", false))
	unlocked_skins = config.get_value("progress", "unlocked_skins", {"shade": true, "neon": true})
	premium_wraith_owned = bool(config.get_value("progress", "premium_wraith_owned", false))
	premium_specter_owned = bool(config.get_value("progress", "premium_specter_owned", false))
	memory_master_reward_claimed = bool(config.get_value("progress", "memory_master_reward_claimed", false))
	check_memory_master_reward()
	if best_grades.has("5"):
		max_unlocked_level = max(max_unlocked_level, 6)


func calculate_grade(time_seconds: float, deaths: int, fragments: int, par_time: float) -> String:
	# S is intentionally prestigious: flawless, complete, and fast.
	if deaths == 0 and fragments >= 3 and time_seconds <= par_time * 0.80:
		return "S"

	var score := 82
	score += fragments * 6
	score -= deaths * 14

	if time_seconds <= par_time:
		score += 8
	else:
		score -= int((time_seconds - par_time) / 2.5)

	if score >= 88:
		return "A"
	if score >= 72:
		return "B"
	return "C"

func submit_grade(level_number: int, grade: String) -> void:
	var order := {"C": 0, "B": 1, "A": 2, "S": 3}
	var key := str(level_number)
	var previous := str(best_grades.get(key, ""))
	if previous == "" or int(order.get(grade, 0)) > int(order.get(previous, -1)):
		best_grades[key] = grade

	if grade == "S" and not bool(s_rank_rewards.get(key, false)):
		s_rank_rewards[key] = true
		shadow_shards += 5

	save_progress()


func submit_time(level_number: int, time_seconds: float) -> bool:
	var key := str(level_number)
	var previous := float(best_times.get(key, 999999.0))
	if time_seconds < previous:
		best_times[key] = time_seconds
		save_progress()
		return true
	return false

func unlock_memory(memory_id: String, memory_text: String) -> void:
	if unlocked_memories.has(memory_id):
		return
	unlocked_memories[memory_id] = memory_text
	check_memory_master_reward()
	save_progress()

func check_memory_master_reward() -> bool:
	if memory_master_reward_claimed:
		return false
	if unlocked_memories.size() < 6:
		return false

	memory_master_reward_claimed = true
	unlocked_skins["echo"] = true
	shadow_shards += 10
	save_progress()
	return true
