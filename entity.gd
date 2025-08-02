class_name Entity
extends CharacterBody2D

@export var health: int = 100
@export var gravity: int = 2500
@export var move_speed: int = 200
@export var attack_power: int = 2

func take_damage(damage: int) -> void:
	health -= damage
	if (health <= 0):
		queue_free()
