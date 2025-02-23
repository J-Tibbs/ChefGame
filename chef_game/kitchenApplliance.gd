extends Area2D

var canOven = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canOven and Input.get_action_raw_strength("MouseClick") == 1:
		print("Cookin")
		canOven = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		if self.is_in_group("Fridge"):
			%CanvasLayer.visible = true
		elif self.is_in_group("Pantry"):
			%CanvasLayer.visible = true
		elif self.is_in_group("Oven"):
			canOven = true
		elif self.is_in_group("StorageSpot"):
			pass


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		
		if self.is_in_group("Fridge"):
			%CanvasLayer.visible = false

		elif self.is_in_group("Pantry"):
			%CanvasLayer.visible = false
		elif self.is_in_group("Oven"):
			canOven = false
		elif self.is_in_group("StorageSpot"):
			pass
