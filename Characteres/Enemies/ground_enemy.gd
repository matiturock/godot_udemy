class_name GroundEnemy extends CharacterBody2D

enum StartDirection { RIGHT, LEFT }

@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var fall_detector_ray_cast_2d: RayCast2D = $FallDetectorRayCast2D

@export_category("Stats")
@export var start_direction: StartDirection = StartDirection.RIGHT
@export var max_speed: int = 50
@export var enemie_death_scene: PackedScene = preload("res://Characteres/Enemies/ground_enemy_death.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.RIGHT
var is_spawning: bool = false


func _ready() -> void:
	is_spawning = true
	
	if start_direction == StartDirection.RIGHT:
		fall_detector_ray_cast_2d.position.x *= -1
		direction = Vector2.LEFT



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_spawning: return
	
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


func kill() -> void:
	var new_enemy_death: Node2D = enemie_death_scene.instantiate()
	new_enemy_death.set_global_position(self.global_position)
	get_parent().add_child(new_enemy_death)
	
	queue_free()


func _on_hurtbox_area_2d_area_entered(_area: Area2D) -> void:
	EventBus.apply_camera_shake(1)
	call_deferred("kill")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		is_spawning = false
