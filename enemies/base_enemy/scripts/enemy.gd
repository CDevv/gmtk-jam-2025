class_name Enemy
extends Entity

enum AttackType { MELEE, RANGED }

@export var type: AttackType = AttackType.RANGED
@export var is_flying: bool = false
@export var sprite_frames: SpriteFrames = load("res://resources/enemies/zombie-anims.tres")
var sprite: AnimatedSprite2D
var target: Player
var walking: bool = true
var attack_timer: Timer

func _ready() -> void:
	sprite = get_node("EnemySprite")
	sprite.sprite_frames = sprite_frames
	attack_timer = get_node("AttackTimer")
	
	if (type == AttackType.MELEE):
		attack_timer.autostart = false
	else:
		attack_timer.autostart = true

# returns true if Player's X is greater, otherwise false
func _get_dir() -> bool:
	var player_x = Game.get_manager().get_player().position.x
	var this_x = position.x
	if (player_x > this_x): return true
	else: return false

func _animate() -> void:
	var dir = _get_dir()
	
	if walking:
		sprite.play("walk")
		if dir: 
			sprite.flip_h = false
		else:
			sprite.flip_h = true

func _ground_physics(_delta: float) -> void:
	var dir = _get_dir()
	
	if walking:
		if dir:
			velocity.x += move_speed
		else:
			velocity.x -= move_speed

func _air_physics(delta: float) -> void:
	var player_pos = Game.get_manager().get_player().position
	var direction = position.direction_to(player_pos)
	if walking and not Game.get_manager().is_player_dead():
		velocity = direction * delta * move_speed * 100

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = 0

	_animate()
	if not is_flying:
		_ground_physics(delta)
	else:
		_air_physics(delta)

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	if type == AttackType.RANGED:
		var player_pos = Game.get_manager().get_player().global_position
		var bullet: Bullet = Game.get_manager().add_projectile(position, player_pos, "fat_ghost_bullet")
		bullet.set_damage(attack_power)
		bullet.set_target_type(Bullet.target_type.PLAYER)
	else:
		if target and target.health > 0:
			target.take_damage(attack_power)

func _on_melee_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		walking = false
		attack_timer.start()

func _on_melee_body_exited(body: Node2D) -> void:
	if body is Player:
		if type == AttackType.MELEE:
			attack_timer.stop()
		target = null
		walking = true

func take_damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		walking = false
		sprite.play("death")
		await sprite.animation_finished
		queue_free()
	var dmg_tween: Tween = create_tween()
	dmg_tween.set_parallel(false)
	dmg_tween.tween_property(sprite, "modulate", Color.FIREBRICK, 0.25)
	dmg_tween.tween_property(sprite, "modulate", Color.WHITE, 0.25)
	dmg_tween.play()
