extends Node

signal coins_update

@export_category("Scenes")
@export var player_scene: PackedScene = preload("res://Characteres/Player/player.tscn")
@export var level_complete: PackedScene = preload("res://UI/level_complete.tscn")

@onready var current_player: CharacterBody2D = $Player

var spawn_position: Vector2 = Vector2.ZERO

var total_coins: int = 0
var collected_coins: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	register_player(current_player)
	load_total_coins()
	load_goal()


func load_total_coins() -> void:
	total_coins = get_tree().get_nodes_in_group("coin").size()
	emit_signal("coins_update", total_coins, collected_coins)


func load_goal() -> void:
	var flag: Flag = get_tree().get_nodes_in_group("goal")[0]
	flag.player_won.connect(on_player_won)


func register_player(player: Player) -> void:
	current_player = player
	spawn_position = current_player.global_position
	current_player.connect("die", on_player_die, CONNECT_DEFERRED)


func create_player() -> void:
	var new_player: Player = player_scene.instantiate()
	new_player.global_position = spawn_position
	add_child(new_player)
	register_player(new_player)


func on_player_die() -> void:
#	current_player.queue_free()
#	create_player()
	get_tree().reload_current_scene()


func coin_collected() -> void:
	collected_coins += 1
	emit_signal("coins_update", total_coins, collected_coins)


func on_player_won() -> void:
	var new_level_complete: CanvasLayer = level_complete.instantiate()
	add_child(new_level_complete)
	#LevelManager.change_level(LevelManager.current_level_index + 1)
