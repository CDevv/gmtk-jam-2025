extends CharacterBody2D

@export var gravity = 2500
@export var move_change = 200
@export var jump_change = 500

func input() -> void:
	velocity.x = 0
	
	var right_press = Input.is_action_pressed("move right")
	var left_press = Input.is_action_pressed("move left")
	var jump_press = Input.is_action_pressed("jump")
	
	if is_on_floor() and jump_press:
		velocity.y = -jump_change
	if left_press:
		velocity.x -= move_change
	if right_press:
		velocity.x += move_change

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	input()
	move_and_slide()
