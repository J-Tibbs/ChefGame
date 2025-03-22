extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 100.0
var HEALTH = 25.0
var DAMAGE = .25
var damage_player = false

func _ready() -> void:
	add_to_group("Enemies")
	
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
	velocity = -(5000 * knockback)
	HEALTH -= damage
	move_and_slide()
	
	if HEALTH <= 0:
		var drop_positions = [
			Vector2(-20, 0),
			Vector2(20, 0),
			Vector2(0, -20)
		]
		
		for offset in drop_positions:
			var honey_drop = preload("res://Art/MuckMan/muckettes.tscn").instantiate()
			get_parent().add_child(honey_drop)
			honey_drop.global_position = global_position + offset
			queue_free()
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()


	

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false
