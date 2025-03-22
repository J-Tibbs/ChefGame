extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")
@onready var spider_web = preload("res://Art/Spider/spider_web.tscn").instantiate()

var SPEED = 390
var HEALTH = 25
var DAMAGE = .25
var damage_player = false
var hunting = false
var flee = false
var my_web
var step = false

func _ready() -> void:
	add_to_group("Enemies")
	call_deferred("_spawn_web")
	
func _physics_process(delta):
	var direction
	if flee and !hunting:
		direction = -global_position.direction_to(player.global_position)
		velocity = SPEED * direction
		move_and_slide()
	if hunting:
		direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction
		move_and_slide()
	if damage_player:
		player.player_hurt(DAMAGE) 
	if my_web and not hunting and not step:
		step = true
		my_web.web_stepped_on.connect(change_to_hunt)
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(3000 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Spider/spider_stuff.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position
		
		my_web.queue_free()
		
		queue_free()

func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	my_web.queue_free()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and hunting:
		damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and hunting:
		damage_player = false


func _on_hide_away_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !hunting:
		flee = true


func _on_hide_away_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and !hunting:
		flee = false

func change_to_hunt():
	hunting = true
	
func _spawn_web():
	spider_web = preload("res://Art/Spider/spider_web.tscn").instantiate()
	spider_web.global_position = global_position
	get_parent().add_child(spider_web)
	my_web = spider_web
