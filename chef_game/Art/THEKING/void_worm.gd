extends CharacterBody2D

@onready var player = get_node("/root/Node2D/Player")
@onready var attackList = [
	"spiral",
	"burst",
	"summon",
	"spike"
]
var SPEED = 0
var BULLETSPEED = 600
var HEALTH = 150
var DAMAGE = 30
var shouldMove = true
var spiral_shots_fired = 0
var shots_fired = 0
var angles_set_1 = []
var angles_set_2 = []
var using_set_1 = true
var current_attack
var new_attack
var target_position = Vector2.ZERO
var circle_move = true
var spike_count = 0


func _ready() -> void:
	%AnimatedSprite2D.play()
	add_to_group("Enemies")
	%CanvasLayer.visible = true
	%Circle.visible = false
	# Define two different angle sets
	for i in range(0, 360, 10):
		if (i/2) % 2 != 1:
			angles_set_1.append(i)
	for i in range(0, 360, 10):
		if (i/2) % 2 == 1:
			angles_set_2.append(i)


func _physics_process(delta: float) -> void:
	%AttackTimer.value = %UntilAttack.time_left + 1
	if circle_move:
		%Circle.global_position = player.global_position

func _process(delta):
	var look_direction= player.global_position

	%Node2D.look_at(look_direction)
	%Node2D.rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	HEALTH -= damage
	%BossHealth.value = HEALTH
	if HEALTH <= 0:
		var drop_positions = [
			Vector2(-30, 0),
			Vector2(30, 0),
			Vector2(0, -30)
		]
		var honey_drop = preload("res://Art/THEKING/void_sauce.tscn").instantiate()
		var toxin_gland = preload("res://Art/THEKING/void_cabbage.tscn").instantiate()
		var worm_meat = preload("res://Art/THEKING/worm_meat.tscn").instantiate()
		get_parent().add_child(honey_drop)
		get_parent().add_child(toxin_gland)
		get_parent().add_child(worm_meat)
		honey_drop.global_position = drop_positions[0] + global_position
		toxin_gland.global_position = drop_positions[1] + global_position
		worm_meat.global_position = drop_positions[2] + global_position
		%CanvasLayer.visible = false
		queue_free()

func _getDamage() -> float:
	return DAMAGE

func despawn():

	queue_free()

func shoot(offset_list, origin):
	const bullet = preload("res://Art/THEKING/void_bullet.tscn")
	for offset in offset_list:
		var new_bullet = bullet.instantiate()
		new_bullet.damage = DAMAGE
		new_bullet.speed = BULLETSPEED
		new_bullet.global_position = origin.global_position
		new_bullet.global_rotation = origin.global_rotation + deg_to_rad(offset)
		get_parent().add_child(new_bullet)
	
		

func _on_until_burst_timeout() -> void:
	shots_fired = 0
	
func spiral_attack():
	if spiral_shots_fired < 20:
		if using_set_1:
			shoot(angles_set_1, %FirePoint)
		else:
			shoot(angles_set_2, %FirePoint)
		
		spiral_shots_fired += 1
		using_set_1 = !using_set_1
		get_tree().create_timer(0.3).timeout.connect(spiral_attack)
	else:
		spiral_shots_fired = 0
		
	%UntilAttack.start()

func shot_attack():
	var three_offsets = [-30, -15, 0, 15, 30]

	if shots_fired < 15:
		shoot(three_offsets, %Targeted)
		shots_fired += 1
		get_tree().create_timer(0.3).timeout.connect(shot_attack)
	%UntilAttack.start()

func spike_attack():
	%Circle.visible = true
	%SpikeTimer.start()
	%UntilAttack.start()

func summon_attack():
	var radius = 100
	
	for i in range(3):
		var summon = load("res://Art/THEKING/void_head.tscn").instantiate()
		var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		summon.global_position = global_position + random_offset
		get_parent().add_child(summon)
		
	%UntilAttack.start()


func _on_until_attack_timeout() -> void:
	new_attack = attackList.pick_random()
	while new_attack == current_attack:
		new_attack = attackList.pick_random()
	
	current_attack = new_attack
	
	if new_attack == "spiral":
		spiral_attack()
	if new_attack == "burst":
		shot_attack()
	if new_attack == "summon":
		summon_attack()
	if new_attack == "spike":
		spike_attack()
		


func _on_spike_timer_timeout() -> void:
	spike_count = 0
	circle_move = false
	var delay_timer = get_tree().create_timer(.5)
	delay_timer.timeout.connect(_summon_spike)
	
func _summon_spike() -> void:
	var summon = load("res://Art/THEKING/thorns.tscn").instantiate()
	get_parent().add_child(summon)
	summon.global_position = %Circle.global_position
	spike_count += 1
	
	if spike_count >= 3:
		circle_move = true
		%Circle.visible = false
		spike_count = 0

		return
	_summon_spike()
