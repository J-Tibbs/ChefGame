extends Area2D

var throw_away = false
var player

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseClick") and throw_away:
		player.update_current_ingred("", null)



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		throw_away = true
		player = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		throw_away = false
