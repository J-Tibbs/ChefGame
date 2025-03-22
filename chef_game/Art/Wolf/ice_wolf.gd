extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")

var SPEED = 300
var HEALTH = 20
var DAMAGE = 20
var isRunning = false
var canDamage = false
var look_direction
var facing_threshold = 15.0
var isSeen = false

func _ready() -> void:
	add_to_group("Enemies")
	
func _physics_process(delta):
	if not isSeen and not isRunning:
		var direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction
		move_and_slide()
	if isRunning:
		var direction = -global_position.direction_to(player.global_position)
		velocity = 450 * direction
		move_and_slide()
	if canDamage:
		canDamage = false
		isRunning = true
		player.player_hurt(DAMAGE)
		%RunAway.start()

func _process(delta):
	if not isRunning:
		look_direction = player.global_position
	if isRunning:
		look_direction = global_position + (global_position - player.global_position).normalized() * 100
	look_at(look_direction)
	rotation_degrees -= 90


func is_player_looking_at(areThey : bool):
	isSeen = areThey
	
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(3000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Wolf/ice_meat.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	queue_free()	

func _on_run_away_timeout() -> void:
	isRunning = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	canDamage = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	canDamage = false
