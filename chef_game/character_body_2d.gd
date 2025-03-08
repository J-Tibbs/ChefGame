extends CharacterBody2D


#Potential Idea, monsters are trying to break in so you have to balance between defending and serving customers
#Patience to 


#ISSUE ISSUE ISSUE THE FRICKEN TICKET SYSTEM
# I THINK IT"S ONLY DUPLICATE RECIPES TURNING EMPTY
#IM NOT SURE WHAT'S UP BUT I THINK THAT SINCE THEYRE ARRAYS, THEY GET REFERENCED BY SELF RATHER TAHN VALUE
#SO SEE IF YOU CAN MAKE IT SO WHEN ONE RECIPE GETS FINISHED, THE REST OF THEM WITH THAT NAME DONT LOSE THEIR VALUE!!!!

@onready var animatedSprite = $AnimatedSprite2D
var moveSpeed = 400
var attackAnim = false
var fire_once = 1
var health = 100
var money = 0
var canMove = true
var ingredients = {"Honey": 0}
var activeRecipe = null
var recipeList = []
var currentStep = null
var currentStepDone = false


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
	
	var overlapping_mobs = %Hitbox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		for mob in overlapping_mobs:
			if mob.is_in_group("Enemies"):
				player_hurt(mob._getDamage())


	

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
		print("player dead")	
func player_heal(heal_amount) -> void:
	health += heal_amount
	%ProgressBar.value = health

func setMoving(can) -> void:
	canMove = can
func getMoving() -> bool:
	return canMove

func get_ingredient(ingred_name) -> void:
	if !ingredients.has(ingred_name):
		ingredients[ingred_name] == 0
	ingredients[ingred_name] += 1
	
func update_ui(amount):
	$CanvasLayer/Score.text = str(amount)
	
func add_recipe(recipe):
	if recipe[1] != []:
		recipeList.append(recipe)
		print(recipe)
	else:
		pass
	if len(recipeList) >= 1 and activeRecipe == null:
		update_current_recipe()
		
		
#i want the list to be made up of ("name", [step1-3])
func get_current_step():
	return currentStep

func end_current_step():
	activeRecipe[1].pop_front()
	if activeRecipe[1].is_empty():
		finish_recipe()
			
	elif activeRecipe[1][0] != null:
		currentStep = activeRecipe[1][0]
		print(currentStep)
	
	if currentStep == null:
		%"Current Step".text = ""
	else:	
		%"Current Step".text = currentStep
	
func finish_recipe():
	print("RecipeFinished!")
	gain_money(100)

	currentStep = null
	if !(recipeList.is_empty()):
		update_current_recipe()
	else:
		activeRecipe = null

func update_current_recipe():
	activeRecipe = null
	currentStep = null
	if recipeList[0][1] != []:
		activeRecipe = recipeList.pop_front()
	#recipeList.pop_front()
		print(activeRecipe)
		currentStep = activeRecipe[1][0]
		%"Current Step".text = currentStep
		print(currentStep)
		
func get_current_money():
	return money
func gain_money(amount):
	money += amount
	update_ui(money)
func lose_money(amount):
	money -= amount
	update_ui(money)
