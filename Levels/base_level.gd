extends Node

@export var player_scene: PackedScene = preload("res://Characteres/Player/player.tscn")
var spawn_position: Vector2 = Vector2.ZERO

@onready var current_player: CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_position = current_player.global_position
	register_player(current_player)


func register_player(player: Player) -> void:
	current_player = player
	current_player.connect("die", on_die_player, CONNECT_DEFERRED)


func create_player() -> void:
	var new_player: Player = player_scene.instantiate()
	new_player.global_position = spawn_position
	add_child(new_player)
	register_player(new_player)


func on_die_player() -> void:
	current_player.call_deferred("queue_free")
	create_player()
