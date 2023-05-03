extends Node2D

signal player_won

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.connect("area_entered", change_level)
	pass # Replace with function body.


func change_level() -> void:
	print("Change level")
	emit_signal("player_won")
