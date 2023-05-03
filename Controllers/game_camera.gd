extends Camera2D

@export var background_color: Color
@export var speed_smoothing: float = 10.0


func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
	set_position_smoothing_speed(speed_smoothing)


func _process(_delta: float) -> void:
	global_position = get_player_position_or_Vector2ZERO()


func get_player_position_or_Vector2ZERO() -> Vector2:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players:
		var player: Player = players[0] as Player
		return player.global_position
	else:
		return Vector2.ZERO
