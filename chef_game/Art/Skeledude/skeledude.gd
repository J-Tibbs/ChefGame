extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")

var SPEED = 225
var HEALTH = 30.0
var DAMAGE = 35
var damage_player = false
var canMove = true
var canRotate = true
var target_position = Vector2.ZERO
var canDamage = false
var attacking = false
var hasHit = false

func _ready() -> void:
	add_to_group("Enemies")
	target_position = player.global_position
	%Area2D.set_deferred("disabled", true)

func _physics_process(delta):
	if canMove and not attacking:
		var direction = global_position.direction_to(target_position)
		velocity = SPEED * direction
	
		# Stop moving when reaching the marked position
		if global_position.distance_to(target_position) < 150:
			velocity = Vector2.ZERO
			bone_attack()

	move_and_slide()
	
func _process(delta):
	if canRotate:
		look_at(target_position)
		rotation_degrees -= 90

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(50 * knockback)
	HEALTH -= damage
	move_and_slide()
	
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Skeledude/bone.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()

func despawn():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canDamage = true
		if not hasHit and attacking:
			player.player_hurt(DAMAGE)
			hasHit = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canDamage = false
		hasHit = false	

func _on_timer_timeout() -> void:
	attacking = false
	canRotate = true
	%Area2D.visible = false
	%Area2D.set_deferred("disabled", true)
	mark_new_target()
	%GotStuck.start()
func bone_attack():
	if attacking:
		return

	%GotStuck.stop()
	attacking = true
	canRotate = false
	velocity = Vector2.ZERO
	%Timer.start()
	get_tree().create_timer(.5).timeout.connect(_enable_attack_area)
	


func mark_new_target():
	target_position = player.global_position

func _on_got_stuck_timeout() -> void:
	if attacking:
		return
	mark_new_target()
	canMove = true
	
func _enable_attack_area():
	%Area2D.visible = true
	%Area2D.set_deferred("disabled", false)
	if canDamage and not hasHit:
		player.player_hurt(DAMAGE)
		hasHit = true
