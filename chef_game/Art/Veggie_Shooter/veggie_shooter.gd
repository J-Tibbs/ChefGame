extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 100.0
var HEALTH = 15.0
var DAMAGE = 8
var canShoot = false
var shouldMove = true

func _ready() -> void:
	add_to_group("Enemies")
	
func _physics_process(delta):

	if shouldMove:
		var move_direction = global_position.direction_to(player.global_position)
		velocity = SPEED * move_direction
		move_and_slide()
		
func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(10000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Veggie_Shooter/leaf_veggie.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
func _getDamage() -> float:
	
	return DAMAGE
	
func despawn():
	queue_free()

func shoot():
	if canShoot:
		const bullet = preload("res://Art/Veggie_Shooter/veggie_bullet.tscn")
		var new_bullet = bullet.instantiate()
		new_bullet.damage = DAMAGE
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)


func _on_timer_timeout() -> void:
	shoot()


func _on_target_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		%Timer.start()
		canShoot=true
		shouldMove = false
		


func _on_target_range_body_exited(body: Node2D) -> void:
	canShoot=false
	shouldMove = true
