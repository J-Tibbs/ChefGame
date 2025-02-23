extends Area2D

var orders = []
var canTakeOrder = false
@onready var player = get_node("/root/Node2D/Player")
var meal_values = {
	"Debug Meal": ["cut", "mix", "prep"]
	
}

var debugMealR = ["Debug Meal", ["cut", "mix", "prep"]]
var orderList = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_action_raw_strength("MouseClick") == 1 and canTakeOrder:
		print("Recipe Get")
		canTakeOrder = false
		player.add_recipe(debugMealR)
		

func orderToMeal(order):
	var ticket_name = [order, meal_values[order]]
	return ticket_name

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canTakeOrder = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canTakeOrder = false
