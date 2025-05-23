extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 200.0
var HEALTH = 15.0
var DAMAGE = .4
var damage_player = false

func _ready() -> void:
	add_to_group("Enemies")
	
func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = SPEED * direction

	move_and_slide()
	if damage_player:
		player.player_hurt(DAMAGE) 
		
func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(5000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()


	

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):

		damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false
