extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 100.0
var HEALTH = 15.0
var DAMAGE = 0.0
var isRunning = false

func _ready() -> void:
	add_to_group("Enemies")
	
func _physics_process(delta):
	if isRunning:
		
		var direction = -global_position.direction_to(player.global_position)
		velocity = SPEED * direction
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction

	move_and_slide()


func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(2500 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Whisps/whisp_fruit.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isRunning = true
		player.set_speed(170)



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isRunning = false
		player.set_speed(400)
