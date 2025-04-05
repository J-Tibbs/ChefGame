extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")

var SPEED = 0
var BULLETSPEED = 600
var HEALTH = 20
var DAMAGE = 16
var shouldMove = true
var shots_fired = 0
var angles_set_1 = []
var angles_set_2 = []
var using_set_1 = true
func _ready() -> void:
	add_to_group("Enemies")
	%UntilBurst.start()
	
	# Define two different angle sets
	for i in range(0, 360, 10):
		if (i/2) % 2 != 1:
			angles_set_1.append(i)
	for i in range(0, 360, 10):
		if (i/2) % 2 == 1:
			angles_set_2.append(i)

#func _process(delta):
	#var look_direction = player.global_position
	#look_at(look_direction)
	#rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(0 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var drop_positions = [
			Vector2(-30, 0),
			Vector2(30, 0),
		]
		var honey_drop = preload("res://Art/MushroomBloke/mushroom.tscn").instantiate()
		var toxin_gland = preload("res://Art/MushroomBloke/toxin_gland.tscn").instantiate()
		get_parent().add_child(honey_drop)
		get_parent().add_child(toxin_gland)
		honey_drop.global_position = drop_positions[0] + global_position
		toxin_gland.global_position = drop_positions[1] + global_position
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():
	print("Being despawned")
	queue_free()

func shoot(offset_list):
	const bullet = preload("res://Art/MushroomBloke/toxic_bullet.tscn")
	for offset in offset_list:
		var new_bullet = bullet.instantiate()
		new_bullet.damage = DAMAGE
		new_bullet.speed = BULLETSPEED
		new_bullet.global_position = %FireSpot.global_position
		new_bullet.global_rotation = %FireSpot.global_rotation + deg_to_rad(offset)
		get_parent().add_child(new_bullet)

func three_fire():
	if shots_fired < 10:
		if using_set_1:
			shoot(angles_set_1)
		else:
			shoot(angles_set_2)
		
		shots_fired += 1
		%Attack.play()
		using_set_1 = !using_set_1
		get_tree().create_timer(0.3).timeout.connect(three_fire)
		
	%UntilBurst.start()

func _on_until_burst_timeout() -> void:
	shots_fired = 0
	three_fire()
