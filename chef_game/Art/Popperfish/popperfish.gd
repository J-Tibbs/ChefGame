extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 100
var HEALTH = 25
var DAMAGE = 100
var damage_player = false
var explode = false

func _ready() -> void:
	add_to_group("Enemies")
	%Explosion.visible = false
	%Popperfish.visible = true
func _physics_process(delta):
	var direction
	if not explode:
		direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction
		move_and_slide()


func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(3000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Popperfish/kaBOOM.tscn").instantiate()
		honey_drop.global_position = global_position
		get_parent().add_child(honey_drop) 
		
		
		queue_free()

func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()


func _on_timer_timeout() -> void:
	explosion()
	


func _on_kaboom_body_entered(body: Node2D) -> void:
	damage_player = true
	if !explode:
		explode = true
		%Timer.start()


func _on_kaboom_body_exited(body: Node2D) -> void:
	damage_player = false

func explosion():
	%Explosion.visible = true
	%Popperfish.visible = false
	if damage_player:
		player.player_hurt(DAMAGE)
	await get_tree().create_timer(.3).timeout
	var honey_drop = preload("res://Art/Popperfish/kaBOOM.tscn").instantiate()
	honey_drop.global_position = global_position
	get_parent().add_child(honey_drop) 
	queue_free()
