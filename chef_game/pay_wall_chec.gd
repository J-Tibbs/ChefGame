extends Area2D

var cost
var paid_for = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	if self.is_in_group("forest_one"):
		cost = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.get_current_money() >= cost:
			body.lose_money(cost)
			self.get_parent().queue_free()
