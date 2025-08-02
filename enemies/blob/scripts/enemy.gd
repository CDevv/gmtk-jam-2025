class_name Enemy
extends Entity

enum AttackType { MELEE, RANGED }

@export var type: AttackType = AttackType.RANGED
var sprite: AnimatedSprite2D
var target: Player
var walking: bool = true

func _ready() -> void:
	sprite = get_node("EnemySprite")
	
	if (type == AttackType.MELEE):
		$AttackTimer.autostart = false
	else:
		$AttackTimer.autostart = true

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = 0
	
	var player_x = Game.get_manager().get_player().position.x
	var this_x = position.x
	
	if walking:
		sprite.play("walk")
		if player_x > this_x:
			velocity.x += move_speed
			sprite.flip_h = false
		elif player_x < this_x:
			velocity.x -= move_speed
			sprite.flip_h = true

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	if type == AttackType.RANGED:
		var player_pos = Game.get_manager().get_player().global_position
		Game.get_manager().add_projectile(position, player_pos, Bullet.target_type.PLAYER, attack_power)
	else:
		if target:
			target.take_damage(attack_power)

func _on_melee_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		walking = false
		%AttackTimer.start()
		
func _on_melee_body_exited(body: Node2D) -> void:
	if body is Player:
		%AttackTimer.stop()
		target = null
		walking = false
	
func take_damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		print("death")
		walking = false
		sprite.play("death")
		await sprite.animation_finished
		queue_free()
	var dmg_tween: Tween = create_tween()
	dmg_tween.set_parallel(false)
	dmg_tween.tween_property(sprite, "modulate", Color.FIREBRICK, 0.25)
	dmg_tween.tween_property(sprite, "modulate", Color.WHITE, 0.25)
	dmg_tween.play()
