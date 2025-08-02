class_name Enemy
extends Entity

var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = get_node("EnemySprite")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = 0
	
	var player_x = Game.get_manager().get_player().position.x
	var this_x = position.x
	
	if player_x > this_x:
		velocity.x += move_speed
		sprite.flip_h = false
	elif player_x < this_x:
		velocity.x -= move_speed
		sprite.flip_h = true

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	var player_pos = Game.get_manager().get_player().global_position
	Game.get_manager().add_projectile(position, player_pos, Bullet.target_type.PLAYER)
	
func take_damage(damage: int) -> void:
	super.take_damage(damage)
	var dmg_tween: Tween = create_tween()
	dmg_tween.set_parallel(false)
	dmg_tween.tween_property(sprite, "modulate", Color.FIREBRICK, 0.25)
	dmg_tween.tween_property(sprite, "modulate", Color.WHITE, 0.25)
	dmg_tween.play()
