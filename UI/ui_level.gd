extends CanvasLayer

@onready var coin_label: Label = $MarginContainer/HBoxContainer/CoinLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var base_levels = get_tree().get_nodes_in_group("base_level")
	
	if base_levels.size() > 0:
		base_levels[0].coins_update.connect(on_coins_update)


func on_coins_update(total_coins: int, collected_coins: int) -> void:
	coin_label.text = str(collected_coins, "/", total_coins)
