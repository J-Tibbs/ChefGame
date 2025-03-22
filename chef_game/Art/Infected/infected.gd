extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")
@onready var open_skins = [
	"res://Art/Infected/infected1.png",
	"res://Art/Infected/infected2.png",
	"res://Art/Infected/infected4.png",
	"res://Art/Infected/infected5.png",
	"res://Art/Infected/infected6.png",
	"res://Art/Infected/infected7.png",
	"res://Art/Infected/infected8.png"
]

var SPEED = 100.0
var HEALTH = 10.0
var DAMAGE = .4
var damage_player = false
var host

func _ready() -> void:
	add_to_group("Enemies")
	host = open_skins.pick_random()
	%Host.texture = load(host)
	
	
func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = SPEED * direction

	move_and_slide()
	if damage_player:
		player.player_hurt(DAMAGE) 

func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	var knockback = global_position.direction_to(attack_pos)
	velocity = -(100 * knockback)
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var drop_positions = [
			Vector2(-30, 0),
			Vector2(30, 0),
		]
		var honey_drop = preload("res://Art/Infected/orange_flower.tscn").instantiate()
		var stone_sauce = preload("res://Art/Infected/orange_sauce.tscn").instantiate()
		get_parent().add_child(honey_drop)
		get_parent().add_child(stone_sauce)
		honey_drop.global_position = drop_positions[0] + global_position
		stone_sauce.global_position = drop_positions[1] + global_position
		queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()


	

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_speed(200)
		damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false
		body.set_speed(400)
