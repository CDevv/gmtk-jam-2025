class_name Enemy
extends Entity

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = 0
	
	var player_x = Game.get_manager().get_player().position.x
	var this_x = position.x
	
	if player_x > this_x:
		velocity.x += move_speed
	elif player_x < this_x:
		velocity.x -= move_speed

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	var player_pos = Game.get_manager().get_player().global_position
	Game.get_manager().add_projectile(position, player_pos, Bullet.target_type.PLAYER)
