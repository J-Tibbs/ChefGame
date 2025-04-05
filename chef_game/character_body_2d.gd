extends CharacterBody2D


#Potential Idea, monsters are trying to break in so you have to balance between defending and serving customers
#Patience to 


@onready var animatedSprite = $AnimatedSprite2D
@onready var hooray = %Confetti
@onready var cash_register = load("res://recipe_pricing.tscn").instantiate()
var moveSpeed = 400
var attackAnim = false
var fire_once = 1
var health = 200
var money = 10000
var canMove = true
var SHOW_NAME_INDEX = 0
var AMOUNT_INDEX = 1
var VALUE_INDEX = 2
var TYPE_INDEX = 3

var ingredients = {
#	showName, amount, value, type
	"BasicMeat": ["Meat?", 1000000, 0, "meat"],
	"BasicSauce": ["Sauce?", 1000000, 0, "sauce"],
	"BasicVeggie": ["Veggies?", 10000000, 0, "plant"],
	"Leaf": ["Leaf", 0, 0.1, "plant"],
	"Moss": ["Lump of Moss", 0, 0.1, "plant"],
	"Sunflower": ["Sunflower", 0, 1, "plant"],
	"SlothGoop": ["Plant Goop", 0, 0.25, "plant"],
	"Bone": ["Bone", 0, 1.3, "plant"],
	"RockRock": ["Rock Cabbage", 0, 1.3, "plant"],
	"LampFruit": ["Lantern Fruit", 0, 0.5, "plant"],
	"OrangeFlower": ["Orange Flower", 0 , 1.6, "plant"],
	"mushroom": ["Mushroom", 0, 1.6, "plant"],
	"void_cabbage": ["Void Cabbage", 0, 2.5, "plant"],
	"smallHoney": ["Honey", 0, 0.1, "sauce"],
	"mana_potion": ["Mana Potion", 0, 1, "sauce"],
	"goop_bowl": ["Goop Bowl", 0, 1, "sauce"],
	"Ectoplasm": ["Ectoplasm", 0, 0.25, "sauce"],
	"MusicSauce": ["Music Sauce", 0, 1.3, "sauce"],
	"cuppaWater": ["Cup of Swamp Water", 0, 0.5, "sauce"],
	"slug_slime": ["Slug Slime", 0, 0.5, "sauce"],
	"kaBOOOM": ["Explosive Sauce", 0, 1.9, "sauce"],
	"stone_sauce": ["Stone Sauce", 0, 1.6, "sauce"],
	"daOrangeSauce": ["Orange Flower Juice", 0, 1.6, "sauce"],
	"void_sauce": ["Void Sauce", 0, 2.5, "sauce"],
	"pork": ["Pork", 0, 0.1, "meat"],
	"steak": ["Beef", 0, 1, "meat"],
	"bat_food": ["Bat Meat", 0, 0.25, "meat"],
	"spider_thing": ["Spider Steak", 0, 0.25, "meat"],
	"icy_meat": ["Icy Meat", 0, 1.3, "meat"],
	"whisp_fruit": ["Light Meat", 0, 0.5, "meat"],
	"gator_meat": ["Gator Jerky", 0, 1.9, "meat"],
	"pile_o_mud": ["Pile of Mud", 0, 1.9, "meat"],
	"mimic_meat": ["Mimic Meat", 0, 1.9, "meat"],
	"stone_meat": ["Slab of Stone", 0, 1.6, "meat"],
	"toxinGland": ["Toxin Gland", 0, 1.6, "meat"],
	"worm_meat": ["Worm Meat", 0, 2.5, "meat"]
	
}
var fridge_list = {}
var pantry_list = {}
var activeRecipe = null
var recipeList = []
var currentStep = null
var currentStepDone = false
var seenArray  = []
var ingredientsUsed = []
var currentIngredient = ""
var recipeForPricing

func _ready() -> void:
	%OrderTicket.visible = false
	hooray.play("default")
	%"THE CROWN!!!".visible = false
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var mouseClick = Input.get_action_raw_strength("MouseClick")
	velocity = direction * moveSpeed
	
	if canMove:
		move_and_slide()
	
	if mouseClick != 0 and fire_once == 1:
		attackAnim = true
		animatedSprite.play("Attack")
	elif mouseClick == 0 and attackAnim == false:
		animatedSprite.play("default")
		fire_once = 1
	

	

func _process(delta):
	look_at(get_global_mouse_position())
	rotation_degrees -= 90

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Attack":
		attackAnim = false
		animatedSprite.play("default")
		fire_once = 0
func player_hurt(damage) -> void:
	health -= damage
	%ProgressBar.value = health
	if %ProgressBar.value <= 0:
		death()	
		
func player_heal(heal_amount) -> void:
	health += heal_amount
	if health > 200:
		health = 200
	%ProgressBar.value = health

func setMoving(can) -> void:
	canMove = can
func getMoving() -> bool:
	return canMove

func get_ingredient(ingred_name) -> void:
	%ItemPickUp.play()
	ingredients[ingred_name][AMOUNT_INDEX] += 1
	
func update_ui(amount):
	$CanvasLayer/Score.text = str(amount)
	
func add_recipe(recipe):
	if recipe[1] != []:
		recipeList.append([recipe[0], recipe[1].duplicate()])
		
	else:
		pass
	if len(recipeList) >= 1 and activeRecipe == null:
		update_current_recipe()
		
		
#i want the list to be made up of ("name", [step1-3])
func get_current_step():
	if currentStep != null and currentStep.size() >= 2:
		return currentStep  # Returns `["cut", "plant"]`
	return null
func end_current_step():
	hooray.play("StepDone")
	activeRecipe[1].pop_front()
	if activeRecipe[1].is_empty():
		finish_recipe()
			
	elif activeRecipe[1][0] != null:
		%FinishStep.play()
		currentStep = activeRecipe[1][0]
		
	
	if currentStep == null:
		%"Current Step".text = ""
		%Recipe.text = ""
		%OrderTicket.visible = false
	else:	
		%"Current Step".text = currentStep[0] + " : " + currentStep[1]
		%Recipe.text = activeRecipe[0]
		%OrderTicket.visible = true
	
func finish_recipe():
	gain_money(cash_register.receive_meal(ingredientsUsed, recipeForPricing))
	%FinishRecipe.play()
	player_heal(100)
	currentStep = null
	ingredientsUsed.clear()
	if !(recipeList.is_empty()):
		update_current_recipe()
	else:
		activeRecipe = null

func update_current_recipe():
	activeRecipe = null
	currentStep = null
	if recipeList[0][1] != []:
		activeRecipe = recipeList.pop_front()
		recipeForPricing = len(activeRecipe[1])
	#recipeList.pop_front()
		currentStep = activeRecipe[1][0]
		%OrderTicket.visible = true
		%"Current Step".text = currentStep[0] + " : " + currentStep[1]
		%Recipe.text = activeRecipe[0]
		
func get_current_money():
	return money
func gain_money(amount):
	money += amount
	var total_payment = cash_register.receive_meal(ingredientsUsed, recipeForPricing)
	update_ui(money)
func lose_money(amount):
	money -= amount
	update_ui(money)

func carry_ingred(icon: CompressedTexture2D):
	%Sprite2D.texture = icon
	
func death():
	self.global_position = %SpawnPoint.global_position
	%Death.play()
	lose_money((money / 3))
	if money <= 0:
		money = 0
	health = 150
	%ProgressBar.value = health

func set_speed(speed : int):
	moveSpeed = speed


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("is_player_looking_at"):
		body.is_player_looking_at(true)
		seenArray.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("is_player_looking_at"):
		body.is_player_looking_at(false)
		seenArray.erase(body)

func update_da_fridge():
	fridge_list.clear()  # Clear previous data
	for key in ingredients:
		if ingredients[key][TYPE_INDEX] == "meat" and ingredients[key][AMOUNT_INDEX] != 0:
			fridge_list[key] = ingredients[key]
	return fridge_list
func update_da_pantry():
	pantry_list.clear()  # Clear previous data
	for key in ingredients:
		if ingredients[key][TYPE_INDEX] != "meat" and ingredients[key][AMOUNT_INDEX] != 0:
			pantry_list[key] = ingredients[key]
	return pantry_list
	
func update_current_ingred(ingredient, icon: CompressedTexture2D):
	if ingredient == "":
		currentIngredient = ""
		%Sprite2D.texture = null
	else:
		%Sprite2D.texture = icon
		currentIngredient = ingredient

func lock_in_ingred():
	if currentIngredient != "":
		ingredientsUsed.append(ingredients[currentIngredient][VALUE_INDEX])
		ingredients[currentIngredient][AMOUNT_INDEX] -= 1
	update_current_ingred("", null)


func _on_confetti_animation_finished() -> void:
	if %Confetti.animation == "StepDone":
		hooray.stop()
		hooray.play("default")

func beat_boss():
	self.global_position = %SpawnPoint.global_position
	%"THE CROWN!!!".visible = true
