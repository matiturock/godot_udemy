extends Node

@export var level_scenes: Array[PackedScene]

var current_level_index: int = 0:
	get: return current_level_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_level(current_level_index)


func change_level(level_idex: int) -> void:
	current_level_index = level_idex if level_idex < level_scenes.size() else 0
	get_tree().change_scene_to_packed(level_scenes[current_level_index])
