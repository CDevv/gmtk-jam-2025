class_name Entity
extends CharacterBody2D

@export var health: int = 100
@export var gravity: int = 2500
@export var move_speed = 200

func damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		queue_free()
