extends CharacterBody2D
class_name Enemy

@export var gravity = 2500
@export var health: int = 50
@export var move_change = 100

func damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		queue_free()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	velocity.x = 0
	
	var player_x = Game.get_manager().get_player().position.x
	var this_x = position.x
	
	if player_x > this_x:
		velocity.x += move_change
	elif player_x < this_x:
		velocity.x -= move_change
		
	
	move_and_slide()
