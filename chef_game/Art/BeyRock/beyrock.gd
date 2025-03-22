extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 500.0
var HEALTH = 15.0
var DAMAGE = 30
var damage_player = false
var move_timer = 0.0
var current_direction = Vector2.ZERO

func _ready() -> void:
	add_to_group("Enemies")
	choose_random_direction()
	%DirectionChange.start()
	%AnimatedSprite2D.play()
func _physics_process(delta):
	move_timer += delta
	velocity = SPEED * current_direction
	if velocity == Vector2.ZERO:
		choose_random_direction()
	move_and_slide()

	if damage_player:
		player.player_hurt(DAMAGE)
		damage_player = false



func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	choose_random_direction()
	HEALTH -= damage
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/BeyRock/rock_food.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
		
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()


	

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = true
		current_direction = -current_direction


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false


func _on_direction_change_timeout() -> void:
	choose_random_direction()
	move_timer = 0.0
	%DirectionChange.start()
func choose_random_direction():
	var directions = [
		Vector2(1, 1).normalized(),
		Vector2(-1, 1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, -1).normalized()
	]
	current_direction = directions[randi() % directions.size()]
	
