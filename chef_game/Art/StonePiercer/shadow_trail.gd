extends Area2D

var DAMAGE
var canDamage = false
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canDamage:
		player.player_hurt(DAMAGE)
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player.set_speed(300)
		canDamage = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canDamage = false
		player.set_speed(400)


func _on_timer_timeout() -> void:
	queue_free()
