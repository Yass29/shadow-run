extends CharacterBody2D

const SPEED := 270.0
const JUMP_VELOCITY := -470.0
const NORMAL_COLLISION_SIZE := Vector2(40, 68)
const SHADOW_COLLISION_SIZE := Vector2(76, 22)
const NORMAL_VISUAL_SCALE := Vector2.ONE
const SHADOW_VISUAL_SCALE := Vector2(1.25, 0.60)
const COYOTE_TIME := 0.12
const JUMP_BUFFER_TIME := 0.12
const MAX_FALL_SPEED := 900.0
const SHADOW_MAX_ENERGY := 100.0
const SHADOW_DRAIN_RATE := 30.0
const SHADOW_RECHARGE_RATE := 24.0
const SHADOW_RECOVER_THRESHOLD := 35.0
const DASH_ENERGY_COST := 22.0

var is_shadow := false
var facing := 1.0
var anim_time := 0.0
@export var shadow_dash_enabled := false
var dash_cooldown := 0.0
var dash_latched := false
var dash_flash := 0.0
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var shadow_energy := SHADOW_MAX_ENERGY
var shadow_exhausted := false
var shadow_meter: ProgressBar
var camera_shake := 0.0
var dash_trail: Line2D

@onready var body: Node2D = $Body
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var floor_shadow: Polygon2D = $FloorShadow
@onready var shadow_aura: Polygon2D = $ShadowAura

func _ready() -> void:
	collision.shape.size = NORMAL_COLLISION_SIZE
	body.scale = NORMAL_VISUAL_SCALE
	shadow_aura.modulate.a = 0.0
	collision_mask = 3
	create_shadow_meter()
	create_dash_trail()
	apply_selected_skin()

func _physics_process(delta: float) -> void:
	anim_time += delta
	dash_cooldown = max(dash_cooldown - delta, 0.0)
	dash_flash = max(dash_flash - delta, 0.0)
	camera_shake = max(camera_shake - delta, 0.0)

	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)
		velocity += get_gravity() * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0 and not is_shadow:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		facing = sign(direction)
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 5.0 * delta)

	update_shadow_energy(delta)
	var wants_shadow := Input.is_key_pressed(KEY_SHIFT) and not shadow_exhausted and shadow_energy > 0.0
	set_shadow_mode(wants_shadow)
	handle_shadow_dash()
	shadow_meter.value = shadow_energy
	move_and_slide()
	update_dash_trail(delta)
	update_camera_fx()
	animate_character(direction, delta)

func handle_shadow_dash() -> void:
	var dash_pressed := Input.is_key_pressed(KEY_E)

	if not dash_pressed:
		dash_latched = false
		return

	if dash_latched or not shadow_dash_enabled or not is_shadow or dash_cooldown > 0.0:
		return

	if shadow_energy < DASH_ENERGY_COST:
		return

	dash_latched = true
	dash_cooldown = 0.65
	dash_flash = 0.16
	camera_shake = 0.16
	shadow_energy -= DASH_ENERGY_COST
	velocity.x = facing * 760.0
	velocity.y = 0.0

func create_dash_trail() -> void:
	dash_trail = Line2D.new()
	dash_trail.width = 10.0
	dash_trail.default_color = Color(0.72, 0.42, 1.0, 0.45)
	dash_trail.z_index = -3
	get_parent().add_child(dash_trail)

func update_dash_trail(_delta: float) -> void:
	if dash_trail == null:
		return

	if dash_flash > 0.0:
		dash_trail.add_point(global_position + Vector2(0, 8))

	while dash_trail.get_point_count() > 9:
		dash_trail.remove_point(0)

	if dash_flash <= 0.0 and dash_trail.get_point_count() > 0:
		dash_trail.remove_point(0)

func update_camera_fx() -> void:
	if not has_node("Camera2D"):
		return

	var camera: Camera2D = $Camera2D
	if camera_shake > 0.0:
		var amount := camera_shake / 0.16
		camera.offset = Vector2(sin(anim_time * 85.0) * 5.0, cos(anim_time * 73.0) * 3.0) * amount
	else:
		camera.offset = camera.offset.lerp(Vector2.ZERO, 0.25)

func create_shadow_meter() -> void:
	shadow_meter = ProgressBar.new()
	shadow_meter.position = Vector2(-40, -66)
	shadow_meter.size = Vector2(80, 8)
	shadow_meter.min_value = 0.0
	shadow_meter.max_value = SHADOW_MAX_ENERGY
	shadow_meter.value = shadow_energy
	shadow_meter.show_percentage = false
	shadow_meter.z_index = 30
	add_child(shadow_meter)

func update_shadow_energy(delta: float) -> void:
	if is_shadow:
		shadow_energy = max(shadow_energy - SHADOW_DRAIN_RATE * delta, 0.0)
		if shadow_energy <= 0.0:
			shadow_exhausted = true
	else:
		shadow_energy = min(shadow_energy + SHADOW_RECHARGE_RATE * delta, SHADOW_MAX_ENERGY)
		if shadow_exhausted and shadow_energy >= SHADOW_RECOVER_THRESHOLD:
			shadow_exhausted = false

func set_shadow_mode(enabled: bool) -> void:
	if is_shadow == enabled:
		return

	is_shadow = enabled

	if is_shadow:
		collision.shape.size = SHADOW_COLLISION_SIZE
		collision_mask = 1
	else:
		collision.shape.size = NORMAL_COLLISION_SIZE
		collision_mask = 3

func animate_character(direction: float, delta: float) -> void:
	var base_scale := SHADOW_VISUAL_SCALE if is_shadow else NORMAL_VISUAL_SCALE
	var target_scale := Vector2(base_scale.x * facing, base_scale.y)
	body.scale = body.scale.lerp(target_scale, min(delta * 13.0, 1.0))

	if is_shadow:
		body.modulate = body.modulate.lerp(Color(0.72, 0.45, 1.0, 1.0), min(delta * 10.0, 1.0))
		body.position.y = lerpf(body.position.y, 10.0, min(delta * 12.0, 1.0))
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 12.0, 1.0))
		floor_shadow.scale = floor_shadow.scale.lerp(Vector2(1.6, 0.85), min(delta * 12.0, 1.0))
		floor_shadow.modulate = floor_shadow.modulate.lerp(Color(0.55, 0.30, 1.0, 0.75), min(delta * 10.0, 1.0))
		shadow_aura.modulate = shadow_aura.modulate.lerp(Color(0.72, 0.42, 1.0, 0.42), min(delta * 12.0, 1.0))
		var pulse := 1.0 + sin(anim_time * 8.0) * 0.08
		var dash_boost := 1.55 if dash_flash > 0.0 else 1.0
		shadow_aura.scale = Vector2(1.18 * pulse * dash_boost, 0.82 * pulse)
		if dash_flash > 0.0:
			shadow_aura.modulate = Color(0.95, 0.75, 1.0, 0.72)
		return

	body.modulate = body.modulate.lerp(Color.WHITE, min(delta * 10.0, 1.0))
	floor_shadow.scale = floor_shadow.scale.lerp(Vector2.ONE, min(delta * 10.0, 1.0))
	floor_shadow.modulate = floor_shadow.modulate.lerp(Color(1.0, 1.0, 1.0, 0.35), min(delta * 10.0, 1.0))
	shadow_aura.modulate.a = lerpf(shadow_aura.modulate.a, 0.0, min(delta * 12.0, 1.0))
	shadow_aura.scale = shadow_aura.scale.lerp(Vector2.ONE, min(delta * 10.0, 1.0))

	var moving: bool = abs(direction) > 0.01 and is_on_floor()
	var bob := sin(anim_time * 12.0) * 2.2 if moving else sin(anim_time * 3.0) * 1.0
	body.position.y = lerpf(body.position.y, bob, min(delta * 14.0, 1.0))

	if not is_on_floor():
		body.rotation = lerpf(body.rotation, clamp(velocity.y / 1800.0, -0.16, 0.16), min(delta * 8.0, 1.0))
	elif moving:
		body.rotation = lerpf(body.rotation, sin(anim_time * 12.0) * 0.035, min(delta * 12.0, 1.0))
	else:
		body.rotation = lerpf(body.rotation, 0.0, min(delta * 10.0, 1.0))


func apply_selected_skin() -> void:
	if not Engine.has_singleton("GameState") and not has_node("/root/GameState"):
		return

	var state = get_node("/root/GameState")
	if not state.SKINS.has(state.selected_skin):
		return

	var skin = state.SKINS[state.selected_skin]
	if body.has_node("Torso"):
		body.get_node("Torso").color = skin["torso"]
	if body.has_node("Cape"):
		body.get_node("Cape").color = skin["cape"]
	if body.has_node("Head"):
		body.get_node("Head").color = skin["head"]
	if body.has_node("Eyes"):
		body.get_node("Eyes").color = skin["eyes"]
	if body.has_node("Scarf"):
		body.get_node("Scarf").color = skin["scarf"]
	if body.has_node("Core"):
		body.get_node("Core").color = skin["core"]
