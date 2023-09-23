class_name PlayerDeath extends CharacterBody2D

@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D

const SPEED: float = 20.0


func _ready() -> void:
	print(velocity)
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false


func _physics_process(_delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
