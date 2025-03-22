extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 75.0
var HEALTH = 25.0
var DAMAGE = 25
var damage_player = false
var can_charge = true
var canMove = true
var canRotate = true
var inCharge = false
var distance = 0


func _ready() -> void:
	add_to_group("Enemies")
	%Timer.start(randi_range(4,7))
	
func _physics_process(delta):
	const range = 75
	if canMove:
		var direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction

	move_and_slide()
	if inCharge:
		distance += SPEED * delta
		if distance > range:
			cancel_charge()

func _process(delta):
	if canRotate:
		var look_direction= player.global_position

		look_at(look_direction)
		rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(500 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Boar/pork_drop.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	print("Being despawned")
	queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if inCharge == true and body.is_in_group("Player") and damage_player:
		body.player_hurt(DAMAGE)
		cancel_charge()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false
		
func big_hit():
	velocity = 0 * global_position.direction_to(player.global_position)
	distance = 0
	canMove = false
	%ChargeUp.start()


func _on_timer_timeout() -> void:
	if can_charge:
		big_hit()
		


func _on_charge_up_timeout() -> void:
	damage_player = true
	canRotate = false
	can_charge = false
	inCharge = true
	var direction = global_position.direction_to(player.global_position)
	velocity = 1000 * direction

func cancel_charge():
	inCharge = false
	can_charge = true
	canMove = true
	canRotate = true
	damage_player = false
	distance = 0
	%Timer.start(randi_range(4,7))
