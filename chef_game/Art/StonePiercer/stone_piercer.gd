extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")


#If you recognize this monster, uhhhh, i have no excuse


var SPEED = 200.0
var DASHSPEED = 1200.0
var HEALTH = 30.0
var DAMAGE = 50
var TRAILDAMAGE = .2
var damage_player = false
var target_position = Vector2.ZERO
var look_direction
var range = 50
var distance = 0
var dashing = false
var canMove = true
var canRotate = true

func _ready() -> void:
	add_to_group("Enemies")

func _physics_process(delta):
	if canMove and not dashing:
		target_position = player.global_position
		var direction = global_position.direction_to(target_position)
		velocity = SPEED * direction

	if dashing:
		var direction = global_position.direction_to(target_position)
		velocity = DASHSPEED * direction
		distance += DASHSPEED * delta
	
	if distance > range and dashing:
		shadow_trail()
	if global_position.distance_to(target_position) < 15 and dashing:
		end_dash()

	
	move_and_slide()
	
	
	
	if damage_player:
		player.player_hurt(DAMAGE)
		damage_player = false

func _process(delta):
	if canRotate:
		look_direction = target_position
		look_at(look_direction)
		rotation_degrees -= 90

	

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(1000 * knockback)
	HEALTH -= damage
	move_and_slide()
	
	if HEALTH <= 0:
		var drop_positions = [
			Vector2(-30, 0),
			Vector2(30, 0),
		]
		var honey_drop = preload("res://Art/StonePiercer/stone_meat.tscn").instantiate()
		var stone_sauce = preload("res://Art/StonePiercer/stone_sauce.tscn").instantiate()
		get_parent().add_child(honey_drop)
		get_parent().add_child(stone_sauce)
		honey_drop.global_position = drop_positions[0] + global_position
		stone_sauce.global_position = drop_positions[1] + global_position
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	queue_free()


func shadow_trail():
	var trail = preload("res://Art/StonePiercer/shadow_trail.tscn").instantiate()
	if dashing:
		trail.DAMAGE = TRAILDAMAGE
		trail.global_position = global_position
		get_parent().add_child(trail)
		distance = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	damage_player = false

func dash_direction():
	target_position = player.global_position
	


func _on_until_dash_timeout() -> void:
	if not dashing:
		var overshoot = 500
		var dash_direction = global_position.direction_to(player.global_position)
		velocity = 0 * global_position.direction_to(player.global_position)
		SPEED = DASHSPEED
		target_position = player.global_position + (dash_direction * overshoot)
		canMove = false
		canRotate = false
		%WindupTimer.start()


func _on_windup_timer_timeout() -> void:
	dashing = true
	canMove = true
	%UntilStuck.start()


func _on_until_stuck_timeout() -> void:
	end_dash()

func end_dash():
	dashing = false
	canMove = true
	canRotate = true
	distance = 0
	velocity = Vector2.ZERO
	SPEED = 200
	%UntilDash.start()
