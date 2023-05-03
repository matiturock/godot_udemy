extends Marker2D

@export var enemy_scene: PackedScene = null


func _ready() -> void:
	assert(enemy_scene != null)


func spawn_enemy() -> void:
	var new_enemy: Node2D = enemy_scene.instantiate()
	add_child(new_enemy)
