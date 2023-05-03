extends Node

signal coins_update

@export_category("Scenes")
@export var player_scene: PackedScene = preload("res://Characteres/Player/player.tscn")
@export var enemy_marker_postion: PackedScene = preload("res://Characteres/Enemies/enemy_spawner_marker_2d.tscn")
var spawn_position: Vector2 = Vector2.ZERO

@onready var current_player: CharacterBody2D = $Player

var total_coins: int = 0
var collected_coins: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_position = current_player.global_position
	register_player(current_player)
	load_total_coins()
	mark_enemies_position()


func load_total_coins() -> void:
	total_coins = get_tree().get_nodes_in_group("coin").size()
	emit_signal("coins_update", total_coins, collected_coins)


func mark_enemies_position() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		var new_spawn_position = enemy_marker_postion.instantiate() as Marker2D
		new_spawn_position.global_position = enemy.global_position
		enemy.get_


func register_player(player: Player) -> void:
	current_player = player
	current_player.connect("die", on_player_die, CONNECT_DEFERRED)


func create_player() -> void:
	var new_player: Player = player_scene.instantiate()
	new_player.global_position = spawn_position
	add_child(new_player)
	register_player(new_player)


func on_player_die() -> void:
	current_player.queue_free()
	create_player()


func coin_collected() -> void:
	collected_coins += 1
	emit_signal("coins_update", total_coins, collected_coins)
