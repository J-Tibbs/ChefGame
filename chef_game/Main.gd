extends Node2D
@onready var path_follow = $Forest1Detect/Path2D/PathFollow2D
var canSpawn = false
var forest_one_enemies = ["res://Art/HoneySlime/HoneySlime.tscn", "res://Art/HoneySlime/BasicHoney.tscn"]
func ready():
	pass
func spawn_mob():
	var current_enemy = forest_one_enemies.pick_random()
	var honey_slime = load(current_enemy).instantiate()
	path_follow.progress_ratio = randf()
	honey_slime.global_position = path_follow.global_position
	add_child(honey_slime)


func _on_timer_timeout() -> void:
	canSpawn = $Forest1Detect.get_player_enter()
	if canSpawn:
		spawn_mob()
