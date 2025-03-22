extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 250.0
var HEALTH = 15.0
var DAMAGE = .5
var isRunning = false
var look_direction
var spawnedRoots = []
var isDead = false

func _ready() -> void:
	add_to_group("Enemies")
	%FireTime.start()
	%Circle.visible = true
	
func _physics_process(delta):
	if isRunning:
		var direction = -global_position.direction_to(player.global_position)
		velocity = SPEED * direction
		move_and_slide()
	
	%Circle.global_position = player.global_position

func _process(delta):
	if !isRunning:
		look_direction= player.global_position
	if isRunning:
		look_direction= -player.global_position
	
	look_at(look_direction)
	rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(5000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/RootMan/manaSauce.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		for root in spawnedRoots:
			root.queue_free()
		isDead = true
		queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	for root in spawnedRoots:
			root.queue_free()
	isDead = true
	queue_free()	


func _on_initial_run_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not isDead:
		isRunning = true
		%FireTime.stop()
		%Circle.visible = false


func _on_run_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and not isDead:
		isRunning = false
		%FireTime.start()
		%Circle.visible = true


func _on_cooldown_timeout() -> void:
	%Circle.visible = true
	%FireTime.start()

func _on_fire_time_timeout() -> void:
	root_attack()
	%Circle.visible = false
	%Cooldown.start()
	%Circle.visible = false
	
func root_attack():
	const roots = preload("res://Art/RootMan/Root.tscn")
	var root = roots.instantiate()
	root.global_position = %Circle.global_position
	get_parent().add_child(root)
	spawnedRoots.append(root)
