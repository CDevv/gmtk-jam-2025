extends Node
class_name GameManager

@export_category('Node references')
@export var player_holder: Node
@export var level_holder: Node
@export var enemy_holder: Node
@export var projectile_holder: Node
@export var ui_holder: Node
@export var camera: Camera2D

@export_category('Predefined spawnable scenes')
@export var player_packed_scene: PackedScene

enum EnemyType { ZOMBIE, GHOST, KNIGHT_GHOST, FAT_GHOST }

func _ready() -> void:
	Game.set_manager(self)
	add_level('test_level_alpha')
	add_player_on_marker()
	add_enemies_on_level()

func add_player(pos: Vector2) -> void:
	var player_to_add: CharacterBody2D = load(player_packed_scene.resource_path).instantiate()
	player_to_add.global_position = pos
	player_holder.add_child(player_to_add)

func add_player_on_marker() -> void:
	var marker_pos = level_holder.get_child(0).get_node("Marker").position
	add_player(marker_pos)

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

func add_enemy(pos: Vector2, enemy_name: String) -> void:
	var full_enemy_path = str("res://enemies/", enemy_name, "/scenes/", enemy_name, ".tscn")
	var enemy_scene = load(full_enemy_path).instantiate()
	enemy_scene.global_position = pos
	enemy_holder.add_child(enemy_scene)

func add_enemies_on_level() -> void:
	var level = level_holder.get_child(0)
	var enemy_min_x = level.get_node("EnemyMarkerStart").position.x
	var enemy_max_x = level.get_node("EnemyMarkerEnd").position.x
	var enemy_y = level.get_node("EnemyMarkerStart").position.y
	for i in range(1, 10):
		var chosen_x = randi_range(enemy_min_x, enemy_max_x)
		var chosen_pos = Vector2(chosen_x, enemy_y)
		var chosen_type = EnemyType.keys().pick_random().to_lower()
		add_enemy(chosen_pos, chosen_type)

func _move_cam_to_target(target: Node2D) -> void:
	camera.global_position = target.global_position

func get_player() -> Player:
	return player_holder.get_child(0)

func add_projectile(pos: Vector2, destination: Vector2, name: String) -> Bullet:
	var bullet_path = str("res://projectiles/", name, "/scenes/", name, ".tscn")
	var bullet_scene = load(bullet_path).instantiate() as Bullet
	bullet_scene.position = pos
	bullet_scene.destination = destination
	projectile_holder.add_child(bullet_scene)
	return bullet_scene
