extends CharacterBody2D

@export var movement_data : PlayerMovementData

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var hazard_sfx: AudioStreamPlayer2D = $HazardDetector/HazardSFX

@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer

@onready var starting_position = global_position

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jump_active = false
var was_wall_normal = Vector2.ZERO

func _ready() -> void:
	coyote_jump_timer.wait_time = movement_data.coyote_max_time
	wall_jump_timer.wait_time = movement_data.wall_jump_max_time

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_wall_jump()
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	apply_friction(direction, delta)
	apply_acceleration(direction, delta)
	apply_air_resistance(direction, delta)
	apply_air_acceleration(direction, delta)
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()

	move_and_slide()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
	
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()
	
	update_animations(direction)

func handle_jump() -> void:
	if is_on_floor():
		air_jump_active = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_pressed("jump"):
			velocity.y = movement_data.jump_velocity
			coyote_jump_timer.stop()
			jump_sfx.play()
	elif not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("jump") and air_jump_active:
			velocity.y = movement_data.jump_velocity * movement_data.air_jump_scale
			air_jump_active = false
			jump_sfx.play()
		
func handle_wall_jump() -> void:
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0: return
	var wall_normal = get_wall_normal()
	if wall_jump_timer.time_left > 0:
		wall_normal = was_wall_normal
	if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
			velocity.x = movement_data.speed * wall_normal.x
			air_jump_active = true
			jump_sfx.play()
		
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

func apply_friction(direction: float, delta: float) -> void:
	if not is_on_floor(): return
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		
func apply_acceleration(direction: float, delta: float) -> void:
	if not is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)

func apply_air_resistance(direction: float, delta: float) -> void:
	if is_on_floor(): return
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func apply_air_acceleration(direction: float, delta: float) -> void:
	if is_on_floor(): return
	if direction != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.air_acceleration * delta)

func update_animations(direction: float) -> void:
	if direction != 0:
		animated_sprite.flip_h = (direction < 0)
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	if not is_on_floor():
		animated_sprite.play("jump")

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	hazard_sfx.play()
	global_position = starting_position
