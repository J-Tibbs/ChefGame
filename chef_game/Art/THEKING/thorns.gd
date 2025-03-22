extends Area2D

var can_damage = false
@onready var player = get_node("/root/Node2D/Player")
func _physics_process(delta: float) -> void:
	if can_damage:
		player.player_hurt(25)
		can_damage = false
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_damage = true
		body.set_speed(100)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_damage = false
		body.set_speed(400)


func _on_timer_timeout() -> void:
	queue_free()
