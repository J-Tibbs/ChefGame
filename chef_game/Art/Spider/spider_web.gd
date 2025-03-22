extends Area2D
var stepped_on = false
signal web_stepped_on

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_speed(100)
		stepped_on = true
		web_stepped_on.emit()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_speed(400)

func get_step():
	return stepped_on
