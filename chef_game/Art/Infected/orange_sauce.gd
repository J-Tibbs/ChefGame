extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("MobDrop")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.get_ingredient("daOrangeSauce")
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
