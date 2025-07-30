extends Node
class_name GameManager

@export_category('Node references')
@export var player_holder: Node
@export var level_holder: Node
@export var enemy_holder: Node
@export var projectile_holder: Node
@export var positional_sound_holder: Node
@export var ui_holder: Node

@export_category('Predefined spawnable scenes')
@export var player_packed_scene: PackedScene

func add_player() -> void:
	var player_to_add: CharacterBody2D = load(player_packed_scene.resource_path).instantiate()
	

func request_level_to_load() -> void:
	pass

func level_loading_check() -> void:
	pass

func add_enemy() -> void:
	pass
