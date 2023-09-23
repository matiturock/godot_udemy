class_name Player extends CharacterBody2D

signal die

enum State { NORMAL, DASH, DEAD }

var player_death_scene: PackedScene = preload("res://Characteres/Player/player_death.tscn")
var footstep_particles: PackedScene = preload("res://Characteres/Player/footsteps_particles.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var hit_dash_collision_shape_2d: CollisionShape2D = $DashArea2D/HitDashCollisionShape2D
@onready var dash_gpu_particles_2d: GPUParticles2D = $DashGPUParticles2D

@export var speed: float = 150.0
@export var dash_speed: float = 400.0
@export var dash_horizontal_desaceleration: float = 10.0
@export var jump_velocity: float = -400.0
@export var horizontal_aceleration: float = 1_500.0
@export var hotizontal_desaceletarion: float = 275.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jump: bool = false
var has_dash: bool = false

var current_state: State = State.NORMAL
var is_state_new: bool = true
var is_death: bool = false

var life: int:
	get: return life
	set(value): 
		if value > life:
			life = 0
		life = value


func _ready() -> void:
	hit_dash_collision_shape_2d.set_deferred("disabled", true)


func _process(delta: float) -> void:
	match current_state:
		State.NORMAL:
			set_process_input(true)
			process_normal(delta)
		State.DASH:
			process_dash(delta)
		State.DEAD:
			set_process_input(false)
		_:
			printerr("Incorrect State")
	
	is_state_new = false


func state_cotroller(new_state: State) -> void:
	current_state = new_state
	is_state_new = true


func process_normal(delta: float) -> void:
	if is_state_new:
		dash_gpu_particles_2d.emitting = false
		hit_dash_collision_shape_2d.set_deferred("disabled", true)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += gravity * delta
	var can_jump: bool = is_on_floor() or not coyote_timer.is_stopped() or has_double_jump
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = jump_velocity
		if not is_on_floor() and coyote_timer.is_stopped():
			EventBus.apply_camera_shake(0.5)
			has_double_jump = false
		coyote_timer.stop()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		velocity.x += horizontal_aceleration * delta
		velocity.x = clampf(velocity.x, -horizontal_aceleration, horizontal_aceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, hotizontal_desaceletarion)
	
	var was_on_floor: bool = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	
	if has_dash and Input.is_action_just_pressed("dash"):
		call_deferred("state_cotroller", State.DASH)
		has_dash = false
	
	update_aniamtion()
	
	if is_on_floor():
		has_double_jump = true
		has_dash = true


func process_dash(_delta: float) -> void:
	if is_state_new:
		dash_gpu_particles_2d.emitting = true
		EventBus.apply_camera_shake(0.75)
		hit_dash_collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("jump")
		var dash_direction: int = 1
		
		if velocity.x != 0:
			dash_direction = sign(velocity.x)
		else:
			dash_direction = 1 if animated_sprite_2d.flip_h else -1
		
		velocity = Vector2(dash_speed * dash_direction, 0)
	
	velocity.x = move_toward(velocity.x, 0.0, dash_horizontal_desaceleration)
	move_and_slide()
	
	if absf(velocity.x) < speed:
		call_deferred("state_cotroller", State.NORMAL)


func update_aniamtion() -> void:
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	elif velocity.x != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if velocity.x != 0:
		animated_sprite_2d.flip_h = velocity.x > 0


func kill() -> void:
	if is_death: return
	is_death = true
	
	EventBus.apply_camera_shake(1)
	var player_death: CharacterBody2D = player_death_scene.instantiate()
	player_death.global_position = self.global_position
	player_death.set_velocity(velocity)
	animated_sprite_2d.set_deferred("visible", false)
	get_parent().add_child(player_death)
	await get_tree().create_timer(1).timeout
	emit_signal("die")


func _on_hazard_area_2d_area_entered(_area: Area2D) -> void:
	call_deferred("kill")


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d.animation == "run" and animated_sprite_2d.frame == 0:
		var particles = footstep_particles.instantiate()
		particles.global_position = self.global_position
		get_parent().add_child(particles)
		print(particles.global_position)
		print(self.global_position)
		pass
