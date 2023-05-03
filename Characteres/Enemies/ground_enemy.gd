class_name GroundEnemy extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fall_detector_ray_cast_2d: RayCast2D = $FallDetectorRayCast2D

enum StartDirection { RIGHT, LEFT }

@export_category("Stats")
@export var start_direction: StartDirection = StartDirection.RIGHT
@export var max_speed: int = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	if start_direction == StartDirection.RIGHT:
		fall_detector_ray_cast_2d.position.x *= -1
		direction = Vector2.LEFT


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction.x * max_speed
	move_and_slide()
	
	animated_sprite_2d.flip_h = direction.x > 0
	
	if not fall_detector_ray_cast_2d.is_colliding():
		toggle_direction()
	
	if is_on_wall():
		toggle_direction()


func toggle_direction() -> void:
	direction.x *= -1
	fall_detector_ray_cast_2d.position.x *= -1


func die() -> void:
	queue_free()


func _on_hurtbox_area_2d_area_entered(_area: Area2D) -> void:
	die()
