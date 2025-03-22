extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")


var SPEED = 70.0
var HEALTH = 10.0
var DAMAGE = .2
var damage_player = false
var target_position = Vector2.ZERO
var look_direction
var range = 45
var distance = 0


func _ready() -> void:
	add_to_group("Enemies")
	choose_new_target()

func _physics_process(delta):
	var direction = global_position.direction_to(target_position)
	velocity = SPEED * direction
	distance += SPEED * delta
	
	if distance > range:
		slime_trail()
		

	if global_position.distance_to(target_position) < 6:
		choose_new_target() 
	
	move_and_slide()
	
	
	
	if damage_player:
		player.player_hurt(DAMAGE)

func _process(delta):
	look_direction = target_position
	look_at(look_direction)
	rotation_degrees -= 90

	

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(1000 * knockback)
	HEALTH -= damage
	move_and_slide()
	
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/SlugGuy/slugSlime.tscn").instantiate()
		get_parent().add_child(honey_drop)
		honey_drop.global_position = global_position
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	queue_free()

func choose_new_target():
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
	target_position = global_position + random_offset

func slime_trail():
	var trail = preload("res://Art/SlugGuy/slimeTrail.tscn").instantiate()
	trail.DAMAGE = DAMAGE
	trail.global_position = global_position
	get_parent().add_child(trail)
	distance = 0
