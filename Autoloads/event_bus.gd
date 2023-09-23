extends Node


func apply_camera_shake(percentage: float) -> void:
	var cameras: Array[Node] = get_tree().get_nodes_in_group("camera2d")
	if cameras.size() > 0:
		var game_camera: GameCamera = cameras[0]
		game_camera.apply_shake(percentage)
