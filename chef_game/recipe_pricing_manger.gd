extends Node


func receive_meal(ingred_list, meal): #this will also take in bonuses from ingredients
	var current_meal = meal
	var total_bonus = 0
	var base = 0
	for bonus in ingred_list:
		total_bonus += bonus
	if meal == 3:
		base = 10
	elif meal == 5:
		base = 20
	elif meal == 7:
		base = 30
	print(base)
	print(total_bonus)
	print(base + (base * total_bonus))
	return base + (base * total_bonus)
