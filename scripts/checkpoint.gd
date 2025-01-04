extends Area2D

@onready var flag_animated_sprite: AnimatedSprite2D = $FlagAnimatedSprite
@onready var activated_sfx: AudioStreamPlayer2D = $ActivatedSFX
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	collision_shape_2d.set_deferred("disabled", true)
	flag_animated_sprite.play("activated")
	activated_sfx.play()
