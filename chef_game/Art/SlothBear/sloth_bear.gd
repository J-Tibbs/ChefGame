extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 100
var HEALTH = 25.0
var DAMAGE = .2
var damage_player = false
var can_charge = true
var canMove = true
var canRotate = true
var target_position = Vector2.ZERO
var look_direction
var canDamage = false

func _ready() -> void:
	add_to_group("Enemies")
	choose_new_target()

	
	
func _physics_process(delta):
	if canMove:
		var direction = global_position.direction_to(target_position)
		velocity = SPEED * direction
		if global_position.distance_to(target_position) < 10:
			choose_new_target()

	move_and_slide()
	if canDamage:
		player.player_hurt(DAMAGE)

func _process(delta):
	look_direction= target_position

		
	look_at(look_direction)
	rotation_degrees += 90
		
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(50 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/SlothBear/SlothGoop.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()


func despawn():
	queue_free()
	
func choose_new_target():
	var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
	target_position = global_position + random_offset


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canDamage = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canDamage = false
