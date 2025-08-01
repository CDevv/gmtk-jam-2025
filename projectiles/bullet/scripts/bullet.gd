class_name Bullet
extends Node2D

@export var damage: int = 20
@export var speed: int = 100
@export var destination: Vector2

var direction: Vector2

func _ready() -> void:
	rotation = position.angle_to(destination)
	direction = position.direction_to(destination)
	look_at(destination)

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.damage(damage)
		queue_free()
