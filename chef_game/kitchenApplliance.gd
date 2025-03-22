extends Area2D

var canOven = false
var cookTime = 3
@onready var player = get_node("/root/Node2D/Player")
var isCookin = false
var fridge_list = []
var pantry_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_raw_strength("MouseClick") == 1 and self.is_in_group("Oven") and canOven:
		var step_data = player.get_current_step()  # Get current step details
		if step_data == null:
			return
		
		var required_action = step_data[0]
		var required_type = step_data[1]

		# Get the type of the currently selected ingredient
		var selected_type = ""
		if player.ingredients.has(player.currentIngredient):
			selected_type = player.ingredients[player.currentIngredient][3]

		# Validate ingredient type before starting the cooking process
		if required_action == "cook" and selected_type != required_type:
			print("Wrong ingredient! This step requires a " + required_type)
			return  # Prevents cooking if wrong ingredient is selected
		
		# Proceed with cooking if the correct ingredient is selected
		%Sprite2D.texture = preload("res://Art/Oven2.png")
		%ProgressBar.visible = true
		cookin_da_food()
		canOven = false

	if isCookin:
		update_ui(%Timer.time_left)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if self.is_in_group("Fridge"):
			update_fridge()
			%CanvasLayer.visible = true
		elif self.is_in_group("Pantry"):
			update_pantry()
			%CanvasLayer.visible = true
		var step_data = player.get_current_step()
		if step_data == null:
			return
		
		var required_action = step_data[0]
		var required_type = step_data[1]
		if self.is_in_group("Oven") and required_action == "cook":
			canOven = true


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
	player.lock_in_ingred()
	%Timer.start()
	isCookin = true
	
		
	
func _on_timer_timeout() -> void:
	player.end_current_step()
	%ProgressBar.visible = false
	isCookin = false
	%Sprite2D.texture = preload("res://Art/Oven1.png")



func _on_item_list_item_activated_fridge(index: int) -> void:
	var selected_key = %ItemList.get_item_metadata(index)
	player.update_current_ingred(selected_key, %ItemList.get_item_icon(index))
	


func _on_item_list_item_activated_pantry(index: int) -> void:
	var selected_key = %ItemList.get_item_metadata(index)
	player.update_current_ingred(selected_key, %ItemList.get_item_icon(index))

func update_fridge():
	%ItemList.clear()
	fridge_list = player.update_da_fridge()
	for key in fridge_list.keys():
		var item_name = fridge_list[key][0]
		var icon_texture = load("res://Art/FoodIcons/" + key + ".png")
		var item_index = %ItemList.add_item(item_name, icon_texture)
		%ItemList.set_item_metadata(item_index, key)
	
func update_pantry():
	%ItemList.clear()
	pantry_list = player.update_da_pantry()
	for key in pantry_list.keys():
		var item_name = pantry_list[key][0]
		var icon_texture = load("res://Art/FoodIcons/" + key + ".png")
		var item_index = %ItemList.add_item(item_name, icon_texture)
		%ItemList.set_item_metadata(item_index, key)
