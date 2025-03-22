extends Area2D

var playerEntered = false
@onready var existing_enemies = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerEntered = true
	if body.is_in_group("Enemies"):
		existing_enemies.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerEntered = false
		despawn_all()
	if body.is_in_group("Enemies"):
		body.queue_free()
		#existing_enemies.remove_at(existing_enemies.find(body))
func get_player_enter():
	return playerEntered
	
func despawn_all():
	for mob in existing_enemies:
		if mob != null and mob.is_inside_tree():
			mob.despawn()
	existing_enemies.clear()
