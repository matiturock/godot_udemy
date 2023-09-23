extends CanvasLayer


func _on_button_pressed() -> void:
	LevelManager.change_level(LevelManager.current_level_index + 1)
