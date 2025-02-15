extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")
var SPEED = 100.0
var HEALTH = 10.0
var DAMAGE = .5

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = SPEED * direction

	move_and_slide()

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(5000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <=0:
		queue_free()
func _getDamage() -> float:
	
	return DAMAGE
