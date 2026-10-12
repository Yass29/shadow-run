extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -450.0

var is_shadow := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_key_pressed(KEY_SHIFT):
		set_shadow_mode(true)
	else:
		set_shadow_mode(false)

	move_and_slide()


func set_shadow_mode(enabled: bool) -> void:
	if is_shadow == enabled:
		return

	is_shadow = enabled

	var sprite = $Sprite2D
	var collision = $CollisionShape2D

	if is_shadow:
		sprite.modulate = Color(0.15, 0.15, 0.2, 1.0)
		sprite.scale = Vector2(1.0, 0.35)

		collision.shape.size = Vector2(70, 30)
	else:
		sprite.modulate = Color.WHITE
		sprite.scale = Vector2(1.0, 1.0)

		collision.shape.size = Vector2(70, 90)
