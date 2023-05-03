extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		animation_player.play("pickup")
		get_tree().root.get_child(0).coin_collected()
