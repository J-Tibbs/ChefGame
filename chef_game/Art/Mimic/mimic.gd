extends CharacterBody2D


@onready var player = get_node("/root/Node2D/Player")

var SPEED = 250
var HEALTH = 25
var DAMAGE = .4
var damage_player = false
var hunting = false
var face 

var faces = [
	"res://Art/Watershroom/watershroom.png",
	"res://Art/HoneySlime/HoneySlime.png",
	"res://Art/LanternToad/lantern_toad.png",
	"res://Art/LaserGuy/glubasaur.png",
	"res://Art/Ghoul/Ghoul.png",
	"res://Art/Gator/gator.png",
	"res://Art/MuckMan/muck_man.png"
]

func _ready() -> void:
	add_to_group("Enemies")
	%MimicTrue.visible = false
	face = faces.pick_random()
	%Facade.visible = true
	%Facade.texture = load(face)
	
func _physics_process(delta):
	if hunting:
		var direction = global_position.direction_to(player.global_position)
		velocity = SPEED * direction

		move_and_slide()
		if damage_player and hunting:
			player.player_hurt(DAMAGE)

func _attacked(attack_pos, damage) -> void:
	if not hunting:
		shape_shift()
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
	global_position += random_offset
	HEALTH -= damage
	move_and_slide()
	if HEALTH <= 0:
		var honey_drop = preload("res://Art/Mimic/mimic_meat.tscn").instantiate()
		get_parent().add_child(honey_drop) 
		honey_drop.global_position = global_position
		queue_free()

func _process(delta):
	var look_direction= player.global_position

	look_at(look_direction)
	rotation_degrees -= 90
func _getDamage() -> float:
	return DAMAGE
	
func despawn():
	queue_free()

func shape_shift():
	if not hunting:
		%Facade.visible = false
		%MimicTrue.visible = true
		hunting = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		damage_player = false
