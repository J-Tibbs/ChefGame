extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 300
var HEALTH = 20.0
var DAMAGE = .35
var damage_player = false
var can_charge = true
var canMove = true
var canRotate = true
var inLaser = false
var canDamage = false
var target_position = Vector2.ZERO
var look_direction
var laser_disabled = true

func _ready() -> void:
	add_to_group("Enemies")
	choose_new_target()
	%laser.set_deferred("disabled", true)
	%Cooldown.start()
	
	
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
	if canRotate and not inLaser:
		look_direction= target_position
	if inLaser and canRotate:
		look_direction = player.global_position
		
	look_at(look_direction)
	rotation_degrees -= 90
		
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(5000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/LaserGuy/sunflower.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()


func despawn():
	queue_free()
	
func choose_new_target():
	var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
	target_position = global_position + random_offset


func _on_cooldown_timeout() -> void:
	#laser attack
	velocity = 0 * global_position.direction_to(player.global_position)

	canMove = false
	
	inLaser = true
	%Aiming.start()


func _on_aiming_timeout() -> void:
	
	canRotate = false
	%laser.visible = true
	%laser.set_deferred("disabled", false)
	laser_disabled = false
	_on_laser_body_entered(player)
	
	
	%LaserAttack.start()

func _on_laser_attack_timeout() -> void:
	%laser.visible = false
	%laser.set_deferred("disabled", true)
	laser_disabled = true
	canMove = true
	canRotate = true
	inLaser = false
	canDamage = false
	choose_new_target()
	%Cooldown.start()
func _on_laser_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and inLaser and not laser_disabled:
		canDamage = true


func _on_laser_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and inLaser and %laser.visible:
		canDamage = false
