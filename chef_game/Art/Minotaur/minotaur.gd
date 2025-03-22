extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var animatedSprite = $AnimatedSprite2D  # Use correct path
@onready var cooldownTimer = $CooldownTimer
@onready var attackTimer = $AttackTimer

var SPEED = 100.0
var HEALTH = 25.0
var DAMAGE = 30
var damage_player = false

func _ready() -> void:
	add_to_group("Enemies")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = SPEED * direction
	move_and_slide()

func _process(delta):
	var look_direction = player.global_position
	look_at(look_direction)
	rotation_degrees -= 90

func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(1000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Minotaur/steak.tscn").instantiate()
		get_parent().add_child(honey_drop)
		honey_drop.global_position = global_position
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	queue_free()

func _on_swing_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if cooldownTimer.is_stopped():
			damage_player = true
			attackTimer.start()

func _on_swing_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false

func _on_attack_timer_timeout() -> void:
	attack()
	cooldownTimer.start()

func attack():
	animatedSprite.stop()
	animatedSprite.play("Swing")
	if damage_player:
		player.player_hurt(DAMAGE)


func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedSprite.animation == "Swing":
		animatedSprite.play("Idle")
