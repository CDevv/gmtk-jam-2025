extends Node

@export var game_manager: GameManager

func set_manager(manager: GameManager) -> void:
	game_manager = manager

func get_manager() -> GameManager:
	return game_manager
