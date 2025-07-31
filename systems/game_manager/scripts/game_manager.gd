extends Node
class_name GameManager

@export_category('Node references')
@export var player_holder: Node
@export var level_holder: Node
@export var enemy_holder: Node
@export var projectile_holder: Node
@export var positional_sound_holder: Node
@export var ui_holder: Node
@export var camera_holder: Node

@export_category('Predefined spawnable scenes')
@export var player_packed_scene: PackedScene

func _ready() -> void:
	Game.set_manager(self)
	add_level()
	add_player(Vector2(0,0))
	add_enemy(Vector2(260, 48))

func add_player(pos: Vector2) -> void:
	var player_to_add: CharacterBody2D = load(player_packed_scene.resource_path).instantiate()
	player_to_add.global_position = pos
	player_holder.add_child(player_to_add)

func add_level() -> void:
	var level_name: String = "test_level_alpha"
	var resource_full_path = str("res://levels/", level_name, ".tscn")
	var level_scene = load(resource_full_path).instantiate()
	level_holder.add_child(level_scene)

func request_level_to_load() -> void:
	pass

func level_loading_check() -> void:
	pass

func add_enemy(pos: Vector2) -> void:
	var enemy_scene = load("res://enemies/blob/scenes/enemy.tscn").instantiate()
	enemy_scene.global_position = pos
	enemy_holder.add_child(enemy_scene)
	
func get_player() -> Player:
	return player_holder.get_child(0)
