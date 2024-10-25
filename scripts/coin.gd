extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	animation_player.play("pickup")
	var coins = get_tree().get_nodes_in_group("Coins")
	if coins.size() == 1:
		Events.level_completed.emit()