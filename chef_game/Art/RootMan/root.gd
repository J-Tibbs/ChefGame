extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_speed(100)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_speed(400)
