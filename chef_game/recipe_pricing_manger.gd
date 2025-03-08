extends Node


func receive_meal(meal): #this will also take in bonuses from ingredients
	var current_meal = meal
	if len(meal[1]) == 3:
		return	10
	if len(meal[1]) == 6:
		return	20
	if len(meal[1]) == 9:
		return	30

func return_coin(amount):
	return amount
