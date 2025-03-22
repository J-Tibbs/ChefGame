extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 0
var HEALTH = 30
var DAMAGE = 16
var shouldMove = true
var shots_fired = 0

func _ready() -> void:
	add_to_group("Enemies")
	%Fire.start()

		
func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(0 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Siren/music_sauce.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
func _getDamage() -> float:
	
	return DAMAGE
	
func despawn():
	print("Being despawned")
	queue_free()

func shoot(offset_list):
		const bullet = preload("res://Art/Siren/note_bullet.tscn")
		for offset in offset_list:
			var new_bullet = bullet.instantiate()
			new_bullet.damage = DAMAGE
			new_bullet.global_position = %ShootingPoint.global_position
			new_bullet.global_rotation = %ShootingPoint.global_rotation + deg_to_rad(offset)  
			get_parent().add_child(new_bullet)




func _on_fire_timeout() -> void:
	shots_fired = 0
	three_fire()
	
func three_fire():
	var three_offsets = [
		[-15, 0, 15],
		[-15, 0 ,15],
		[-15,0, 15]
		]
	if shots_fired < 3:
		shoot(three_offsets[shots_fired])
		shots_fired += 1
		get_tree().create_timer(0.3).timeout.connect(three_fire)
