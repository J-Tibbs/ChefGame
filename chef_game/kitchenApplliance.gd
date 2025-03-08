extends Area2D

var canOven = false
var cookTime = 3
@onready var player = null
var isCookin = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_raw_strength("MouseClick") == 1 and self.is_in_group("Oven") and canOven:
		print("Cookin")
		%ProgressBar.visible = true
		cookin_da_food()
		canOven = false
	if isCookin:
		update_ui(%Timer.time_left)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		if self.is_in_group("Fridge"):
			%CanvasLayer.visible = true
		elif self.is_in_group("Pantry"):
			%CanvasLayer.visible = true
		elif self.is_in_group("Oven") and player.get_current_step() == "cook":
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

func update_ui(amount):
	%ProgressBar.value = amount
	
func cookin_da_food():
	%Timer.start()
	isCookin = true
	
		
	
func _on_timer_timeout() -> void:
	player.end_current_step()
	%ProgressBar.visible = false
	isCookin = false
