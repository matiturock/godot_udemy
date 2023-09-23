extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("death")
	hit_flash_animation_player.play("hit_flash")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
