class_name Player
extends CharacterBody2D

@export_category('Speed and power variables')
@export var gravity = 1500
@export var move_speed = 200
@export var jump_velocity = 500

@export_category('Exported node references')
@export var player_visuals: Node2D

var has_wings: bool = true
var bullet_delayed: bool = false

func _get_input_direction() -> Vector2:
	var dir: Vector2 = Vector2(Input.get_axis("move left", "move right"), 0)
	return dir

func _air_physics(delta: float) -> void:
	var dir: Vector2 = _get_input_direction()

	if dir:
		velocity.x = lerp(velocity.x, dir.x * (move_speed * 2.0), delta * 7.25)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * (move_speed * 0.75))

	if Input.is_action_pressed("jump") and !is_on_floor() and has_wings:
		velocity.y += -(gravity * 3.25) * delta

	velocity.y = clamp(velocity.y, -500, 600)
	velocity.y += gravity * delta

	_directional_tilt(delta)

func _ground_physics(delta: float) -> void:
	var dir: Vector2 = _get_input_direction()

	if dir:
		velocity.x = lerp(velocity.x, dir.x * move_speed, delta * 9.5)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * (move_speed * 2.5))

	if Input.is_action_pressed("jump"):
		velocity.y = -jump_velocity

	if player_visuals.rotation != 0.0:
		player_visuals.rotation = 0.0

func _directional_tilt(delta: float) -> void:
	player_visuals.rotation = lerp(player_visuals.rotation, velocity.x * 0.015, delta * 2.5)
	player_visuals.rotation = clamp(player_visuals.rotation, -deg_to_rad(12), deg_to_rad(12))

func _physics_process(delta: float) -> void:
	Game.game_manager._move_cam_to_target(self)
	if is_on_floor():
		_ground_physics(delta)
	else:
		_air_physics(delta)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if not bullet_delayed:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Game.get_manager().add_projectile(position, get_global_mouse_position())
			bullet_delayed = true
			$Timer.start()
		
func bullet_delay_over() -> void:
	bullet_delayed = false
