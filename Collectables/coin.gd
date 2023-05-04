extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		animation_player.play("pickup")
		get_tree().get_nodes_in_group("base_level")[0].coin_collected()
