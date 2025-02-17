extends Node2D
@onready var path_follow = $Path2D/PathFollow2D
func ready():
	pass
func spawn_mob():
	var honey_slime = preload("res://HoneySlime.tscn").instantiate()
	path_follow.progress_ratio = randf()
	honey_slime.global_position = path_follow.global_position
	add_child(honey_slime)


func _on_timer_timeout() -> void:
	#pass
	spawn_mob()
