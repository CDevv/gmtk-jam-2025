class_name Player
extends Entity

@export_category('Speed and power variables')
@export var jump_velocity: float = 500.0
@export var attack_rate: float = 0.25

@export_category('Exported node references')
@export var player_visuals: Node2D

var has_wings: bool = true
var bullet_delayed: bool = false
var is_flipped: bool = false

func _get_input_direction() -> Vector2:
	var dir: Vector2 = Vector2(Input.get_axis("move left", "move right"), 0)
	return dir

func _air_physics(delta: float) -> void:
	var dir: Vector2 = _get_input_direction()

	if dir:
		velocity.x = lerp(velocity.x, dir.x * (move_speed * 3.0), delta * 7.25)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * (move_speed * 0.75))

	if Input.is_action_pressed("jump") and !is_on_floor() and has_wings:
		velocity.y += -(gravity * 3.25) * delta

	velocity.y = clamp(velocity.y, -500, 600)
	velocity.y += gravity * delta

	_directional_tilt_and_heading(delta)

func _ground_physics(delta: float) -> void:
	var dir: Vector2 = _get_input_direction()

	if dir:
		velocity.x = lerp(velocity.x, dir.x * move_speed, delta * 9.5)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * (move_speed * 2.5))

	if Input.is_action_pressed("jump"):
		velocity.y = -jump_velocity

	_directional_tilt_and_heading(delta)

func _animate_player() -> void:
	if velocity.x != 0.0 and is_on_floor():
		%PlayerSprite.play("walk")
	elif velocity.x == 0.0 and is_on_floor():
		%PlayerSprite.play("idle")
	elif !is_on_floor() and velocity.y < 0:
		%PlayerSprite.play("acsend")
	elif !is_on_floor() and velocity.y > 0:
		%PlayerSprite.play("descend")

	%PlayerSprite.speed_scale = velocity.x * 0.015

func _directional_tilt_and_heading(delta: float) -> void:
	player_visuals.rotation = lerp(player_visuals.rotation, velocity.x * 0.015, delta * 2.5)
	player_visuals.rotation = clamp(player_visuals.rotation, -deg_to_rad(10), deg_to_rad(10))
	if get_local_mouse_position().x < 0:
		%PlayerSprite.flip_h = true
		is_flipped = true
	else:
		%PlayerSprite.flip_h = false
		is_flipped = false

func _shoot_check() -> void:
	if not bullet_delayed:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Game.get_manager().add_projectile(position, get_global_mouse_position(), Bullet.target_type.ENEMY)
			bullet_delayed = true
			await get_tree().create_timer(attack_rate).timeout
			bullet_delayed = false

func _physics_process(delta: float) -> void:
	Game.game_manager._move_cam_to_target(self)
	_shoot_check()
	_animate_player()
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	move_and_slide()
