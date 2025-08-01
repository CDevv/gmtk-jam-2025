class_name Bullet
extends Node2D

enum target_type { PLAYER, ENEMY }

@export var damage: int = 20
@export var speed: int = 100
@export var destination: Vector2
@export var type: target_type

var direction: Vector2

func _ready() -> void:
	rotation = position.angle_to(destination)
	direction = position.direction_to(destination)
	look_at(destination)

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and type == target_type.ENEMY:
		damage_target(body)
	if body is Player and type == target_type.PLAYER:
		damage_target(body)

func set_type(type: target_type) -> void:
	self.type = type

func damage_target(body: Entity) -> void:
	body.damage(damage)
	queue_free()
