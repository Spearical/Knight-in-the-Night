extends Node2D

@onready var left_ray_cast: RayCast2D = $LeftRayCast
@onready var right_ray_cast: RayCast2D = $RightRayCast
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var movement_data : EnemyMovementData

var direction = 1

func _process(delta: float) -> void:
	if left_ray_cast.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	if right_ray_cast.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		
	position.x += direction * movement_data.speed * delta
