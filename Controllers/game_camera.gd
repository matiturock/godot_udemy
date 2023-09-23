class_name GameCamera extends Camera2D

@export var background_color: Color
@export var speed_smoothing: float = 10.0
@export var shake_noice: Noise = null

var x_noice_sample_vector: Vector2 = Vector2.RIGHT
var y_noice_sample_vector: Vector2 = Vector2.DOWN
## position
var x_noice_sample_position: Vector2 = Vector2.ZERO
var y_noice_sample_position: Vector2 = Vector2.ZERO
## travel speed across the noice texture, in pixels per seconds
var noice_sample_travel_rate: int = 600
var max_shake_offset: float = 10
var current_shake_percentage: float = 0.0

var shake_decay: float = 3


func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
	set_position_smoothing_speed(speed_smoothing)


func _process(delta: float) -> void:
	global_position = get_player_position_or_Vector2ZERO()
	
	if current_shake_percentage > 0:
		x_noice_sample_position += x_noice_sample_vector * noice_sample_travel_rate * delta
		y_noice_sample_position += y_noice_sample_vector * noice_sample_travel_rate * delta
		
		var x_sample: float = shake_noice.get_noise_2d(x_noice_sample_position.x, x_noice_sample_position.y)
		var y_sample: float = shake_noice.get_noise_2d(y_noice_sample_position.x, y_noice_sample_position.y)
		
		var calculate_offset: Vector2 = Vector2(x_sample, y_sample) * pow(current_shake_percentage, 2) * max_shake_offset
		offset = calculate_offset
		
		current_shake_percentage = clampf(current_shake_percentage - shake_decay * delta, 0, 1)



func get_player_position_or_Vector2ZERO() -> Vector2:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players:
		var player: Player = players[0] as Player
		return player.global_position
	else:
		return Vector2.ZERO


func apply_shake(percentage: float) -> void:
	current_shake_percentage = clamp(current_shake_percentage + percentage, 0, 1)
