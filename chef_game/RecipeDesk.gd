extends Area2D

var orders = []
var canTakeOrder = false
@onready var player = get_node("/root/Node2D/Player")
@onready var meal_values = {
	"Debug Meal": ["cut", "mix", "prep"],
	"Debug Long Meal": ["cut", "mix", "cut", "mix", "prep", "cut", "mix", "cut", "prep"],
	"Debug Medium Meal": ["mix", "cut", "cut", "mix", "prep", "prep"],
	"Debug Short Cook": ["cut", "cook", "prep"]
}
@onready var simple_meals = { #three long
	"Debug Meal": ["cut", "mix", "prep"],
	"Debug Short Cook": ["cut", "cook", "prep"]
}
@onready var medium_meals = { #six long
	"Debug Medium Meal": ["mix", "cut", "cut", "mix", "prep", "prep"]
}
@onready var long_meals = { #nine long
	"Debug Long Meal": ["cut", "mix", "cut", "mix", "prep", "cut", "mix", "cut", "prep"]
}
var meal_names = [
	"Debug Short Cook"
]
#"Debug Meal", "Debug Long Meal", "Debug Medium Meal", 
var orderList = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_raw_strength("MouseClick") == 1 and canTakeOrder:
		print("Recipe Get")
		canTakeOrder = false
		var meal_name = meal_names.pick_random()
		var meal_ticket = orderToMeal(meal_name)
		if meal_ticket[1] != []:
			player.add_recipe([meal_name, meal_values[meal_name]])
		#player.add_recipe(orderToMeal(meal_names.pick_random()))

		
func customerOrder():
	orderList.append("Debug Meal")
	
func orderToMeal(order):
	var ticket_name = [order, meal_values[order]]
	return ticket_name

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canTakeOrder = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canTakeOrder = false
