class_name Flag extends Node2D

signal player_won

@onready var area_2d: Area2D = $Area2D


func change_level() -> void:
	print("Change level")
	emit_signal("player_won")


func _on_area_2d_area_entered(_area: Area2D) -> void:
	change_level()
