extends Area2D

var player
var damage
var distance = 0
var speed = 500

func _physics_process(delta: float) -> void:
	const range = 2000
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta
	
	distance += speed * delta
	
	if distance > range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		player = body
		player.player_hurt(damage)

func set_damage(amount):
	damage = amount
	
func set_speed(amount):
	speed = amount
