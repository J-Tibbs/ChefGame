extends Node

var recipe_name = ""
var recipe_steps = ["", "", ""]
# Called when the node enters the scene tree for the first time.

func _init(meal_name, meal_steps):
	recipe_name = meal_name
	recipe_steps = meal_steps

func get_meal_name():
	return recipe_name
	
func get_meal_steps():
	return recipe_steps
