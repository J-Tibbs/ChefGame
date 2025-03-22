extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")
var SPEED = 0
var HEALTH = 15
var DAMAGE = 0

func _ready() -> void:
	add_to_group("Enemies")


		
func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
	
func _attacked(attack_pos, damage) -> void:
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/WaterFish/waterCup.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position 
		queue_free()
func _getDamage() -> float:
	
	return DAMAGE
	
func despawn():
	queue_free()

func _on_mist_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var mist = load("res://Art/WaterFish/mist.tscn").instantiate()
		mist.global_position = player.global_position
		get_parent().add_child(mist)


func _on_mist_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		var random_offset = Vector2(randf_range(-300, 300), randf_range(-300, 300))
		global_position += random_offset
