extends Node
class_name GameManager

@export_category('Node references')
@export var player_holder: Node
@export var level_holder: Node
@export var enemy_holder: Node
@export var projectile_holder: Node
@export var positional_sound_holder: Node
@export var ui_holder: Node
@export var camera: Camera2D

@export_category('Predefined spawnable scenes')
@export var player_packed_scene: PackedScene

func _ready() -> void:
	Game.set_manager(self)
	add_level('test_level_alpha')
	add_player(Vector2(32,0))

func add_player(pos: Vector2) -> void:
	var player_to_add: CharacterBody2D = load(player_packed_scene.resource_path).instantiate()
	player_to_add.global_position = pos
	player_holder.add_child(player_to_add)

func add_level(level_name: String) -> void:
	if !level_holder.get_children():
		var resource_full_path = str("res://levels/", level_name, ".tscn")
		var level_scene = load(resource_full_path).instantiate()
		level_holder.add_child(level_scene)
	else:
		for child in level_holder.get_children():
			child.queue_free()
		var resource_full_path = str("res://levels/", level_name, ".tscn")
		var level_scene = load(resource_full_path).instantiate()
		level_holder.add_child(level_scene)

func add_enemy(pos: Vector2, enemy_schene_path: String) -> void:
	var enemy_scene = load(enemy_schene_path).instantiate()
	enemy_scene.global_position = pos
	enemy_holder.add_child(enemy_scene)

func _move_cam_to_target(target: Node2D) -> void:
	camera.global_position = target.global_position

func get_player() -> Player:
	return player_holder.get_child(0)
