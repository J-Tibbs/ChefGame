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
		canDamage = true


func _on_body_exited(body: Node2D) -> void:
	canDamage = false


func _on_timer_timeout() -> void:
	queue_free()
