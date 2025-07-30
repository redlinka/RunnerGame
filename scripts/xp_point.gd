extends Node2D
signal reached_player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		queue_free()
		emit_signal("reached_player")
