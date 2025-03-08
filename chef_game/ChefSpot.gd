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
		is_cooking = true
		player = body		
		if self.is_in_group("CuttingBoard") and can_cook and player.get_current_step() == "cut":
			player.position = self.get_child(0).global_position
			start_cutting()
		elif self.is_in_group("MixingBowl") and can_cook and player.get_current_step() == "mix":
			player.position = self.get_child(0).global_position
			start_mixing()
		elif self.is_in_group("Prep") and can_cook and player.get_current_step() == "prep":
			player.position = self.get_child(0).global_position
			start_prep()
		elif self.is_in_group("StorageSpot"):
			start_storage()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_cook = true
func _input(event: InputEvent) -> void:
	if is_cutting and event is InputEventMouseButton and event.pressed:
		cut_amount += 1
		print("Cut Amount:", cut_amount)
		if cut_amount >= 3:
			reset_states()

	elif is_mixing and event is InputEventMouseMotion:
		mix_rotation += abs(event.relative.x) 
		print("Mix Rotation:", mix_rotation)
		if mix_rotation >= 1500:
			reset_states()

	elif is_prepping and event is InputEventMouseMotion:
		prep_x = event.position.x

		if prep_x <= left_mouse_x and not hit_left:
			hit_left = true
		if prep_x >= right_mouse_x and hit_left:
			hit_left = false
			prep_amount += 1
		print(prep_amount)
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

func start_storage() -> void:
	print("Storing food") 

func reset_states() -> void:
	is_cutting = false
	is_mixing = false
	is_prepping = false
	player.setMoving(true) 
	can_cook = true
	is_cooking = false
	player.end_current_step()
