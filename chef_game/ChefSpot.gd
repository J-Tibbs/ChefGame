extends Area2D

var is_cutting = false
var is_mixing = false
var is_prepping = false
var can_cook = true
var is_cooking = false
var cut_amount = 0
var mix_rotation = 0.0
var prep_x = 0
@onready var left_mouse_x = get_viewport_rect().size.x * 0.3
@onready var right_mouse_x = get_viewport_rect().size.x * 0.7 

var prep_amount = 0 #this will be how many times the mouse is moved past the right marker
var hit_left = false

@onready var player = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		var step_data = player.get_current_step()
		if step_data == null:
			return
		
		var required_action = step_data[0]
		var required_type = step_data[1]

		var selected_type = ""
		if player.ingredients.has(player.currentIngredient):
			selected_type = player.ingredients[player.currentIngredient][3]

		if selected_type != required_type:
			return  # Prevents starting the wrong step
		
		# Start the correct step
		if self.is_in_group("CuttingBoard") and required_action == "cut":
			player.position = self.get_child(0).global_position
			start_cutting()
		elif self.is_in_group("MixingBowl") and required_action == "mix":
			player.position = self.get_child(0).global_position
			start_mixing()
		elif self.is_in_group("Prep") and required_action == "prep":
			player.position = self.get_child(0).global_position
			start_prep()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_cook = true
func _input(event: InputEvent) -> void:
	if is_cutting and event is InputEventMouseButton and event.pressed:
		cut_amount += 1
		if cut_amount >= 3:
			reset_states()

	elif is_mixing and event is InputEventMouseMotion:
		mix_rotation += abs(event.relative.x) 
		if mix_rotation >= 1500:
			reset_states()

	elif is_prepping and event is InputEventMouseMotion:
		prep_x = event.position.x

		if prep_x <= left_mouse_x and not hit_left:
			hit_left = true
		if prep_x >= right_mouse_x and hit_left:
			hit_left = false
			prep_amount += 1
		if prep_amount >= 3:
			reset_states()

func start_cutting() -> void:
	is_cutting = true
	cut_amount = 0
	player.setMoving(false)

func start_mixing() -> void:
	is_mixing = true
	mix_rotation = 0
	player.setMoving(false)

func start_prep() -> void:
	is_prepping = true
	prep_amount = 0
	player.setMoving(false)


func reset_states() -> void:
	player.lock_in_ingred()
	is_cutting = false
	is_mixing = false
	is_prepping = false
	player.setMoving(true) 
	can_cook = true
	is_cooking = false
	player.end_current_step()
