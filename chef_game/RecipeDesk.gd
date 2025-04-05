extends Area2D

var orders = []
var canTakeOrder = false
@onready var player = get_node("/root/Node2D/Player")
@onready var meal_values = {
#	Name: [[],[],[]] Sizes: short: 3, med: 5, long: 7 
# cut, prep, mix, cook, meat, sauce, plant
#--------------------------------Short meals
	"House Salad": [["cut", "plant"],["prep", "sauce"],["mix", ""]],
	"Ribs": [["cut", "meat"],["prep", "sauce"],["cook", ""]],
	"Cooked Veggies": [["cut", "plant"], ["cook", ""], ["prep", "sauce"]],
	"Fruit Salad": [["cut", "plant"], ["mix", ""], ["prep", "sauce"]],
	"Garlic Bread": [["cut", "plant"], ["prep", "sauce"], ["cook", ""]],
	"Mashed Potatoes": [["cut", "plant"], ["cook", ""], ["mix", "sauce"]],
	
#	------------------------Medium meals
	"Hearty Soup": [["cut","meat"],["cut", "plant"],["mix", ""],["mix","sauce"],["cook", ""]],
	"Pasta": [["cut", "meat"], ["mix", "sauce"], ["cut", "plant"], ["cook", ""], ["prep", "sauce"]],
	"Sushi Roll": [["cut", "meat"], ["cut", "plant"], ["prep", ""], ["mix", "sauce"], ["prep", ""]],
	"Stir Fry": [["cut", "meat"], ["cut", "plant"], ["prep", ""], ["mix", "sauce"], ["prep", ""]], 
	"Mushroom Risotto": [["cut", "plant"], ["cook", "sauce"], ["mix", ""], ["prep", "sauce"], ["cook", ""]],
	
#	----------------------------Long Meals
	"Holiday Feast": [["cut", "meat"], ["prep", "sauce"], ["mix", ""], ["cook", "meat"], ["prep", "sauce"], ["cook", ""], ["prep", ""]],
	"Lasagna": [["cut", "meat"], ["mix", "sauce"], ["cook", ""], ["cut", "plant"], ["prep", ""], ["mix", "sauce"], ["cook", ""]],
	"BBQ Platter": [["cut", "meat"], ["cook", "meat"], ["cut", "plant"], ["prep", "sauce"], ["mix", ""], ["cook", ""], ["prep", ""]],
	"Ramen": [["cut", "meat"], ["cut", "plant"], ["cook", ""], ["mix", "sauce"], ["prep", ""], ["cook", ""], ["mix", ""]],
	"Seafood Paella": [["cut", "meat"], ["cut", "plant"], ["mix", ""], ["cook", "sauce"], ["prep", "sauce"], ["cook", ""], ["mix", ""]]
}

var meal_names = [
	"House Salad", "Ribs", "Cooked Veggies", "Fruit Salad", "Garlic Bread", "Mashed Potatoes", "Hearty Soup", "Pasta", "Sushi Roll", "Stir Fry",
	"Mushroom Risotto", "Holiday Feast", "Lasagna", "BBQ Platter", "Ramen", "Seafood Paella"
]
var orderList = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_raw_strength("MouseClick") == 1 and canTakeOrder:
		canTakeOrder = false
		var meal_name = meal_names.pick_random()
		#var meal_ticket = orderToMeal(meal_name)
		%Bell.play()
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
