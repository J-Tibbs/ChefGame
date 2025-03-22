extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var bubble = preload("res://Art/LanternToad/bubble_bullet.tscn")

var SPEED = 500.0
var HEALTH = 10.0
var DAMAGE = 15
var damage_player = false
var target_position = Vector2.ZERO
var jumping = false
var look_direction
var jump_wait_time = 1.0


func _ready() -> void:
	add_to_group("Enemies")
	choose_new_target()

func _physics_process(delta):
	if jumping:
		var direction = global_position.direction_to(target_position)
		velocity = SPEED * direction


		if global_position.distance_to(target_position) < 100:
			velocity = Vector2.ZERO
			jumping = false
			await get_tree().create_timer(jump_wait_time).timeout
			choose_new_target()
	
	move_and_slide()
	
	if damage_player:
		player.player_hurt(DAMAGE)

func _process(delta):
	look_direction = target_position
	look_at(look_direction)
	rotation_degrees -= 90

func _on_until_shoot_timeout() -> void:
	var new_bullet = bubble.instantiate()
	
	var random_angle = randf_range(180, -180)
	new_bullet.rotation_degrees += random_angle
	
	new_bullet.damage = DAMAGE
	new_bullet.global_position = %FirePoint.global_position
	%FirePoint.add_child(new_bullet)
	

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(1000 * knockback)
	HEALTH -= damage
	move_and_slide()
	
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/LanternToad/lamp_fruit.tscn").instantiate()
		get_parent().add_child(honey_drop)
		honey_drop.global_position = global_position
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	queue_free()

func choose_new_target():
	var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
	target_position = global_position + random_offset
	jumping = true
