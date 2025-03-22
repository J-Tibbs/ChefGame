extends Node2D
@onready var pause_menu = $PauseMenu
@onready var player = $Player
@onready var area_data = {
	"forest1": {
		"detector": $Forest1Detect,
		"enemies": [
			{"scene": "res://Art/HoneySlime/HoneySlime.tscn", "weight": 3},
			{"scene": "res://Art/Veggie_Shooter/veggie_shooter.tscn", "weight": 3},
			{"scene": "res://Art/Boar/boar.tscn", "weight": 2},
			{"scene": "res://Art/MossMoth/MossMoth.tscn", "weight": 3}
		],
		"path_follow": $Forest1Detect/Path2D/PathFollow2D
	},
	"forest2": {
		"detector": $Forest2Detect,
		"enemies": [
			{"scene": "res://Art/Watershroom/watershroom.tscn", "weight": 4},
			{"scene": "res://Art/RootMan/root_mage.tscn", "weight": 2},
			{"scene": "res://Art/LaserGuy/LaserGuy.tscn", "weight": 3},
			{"scene": "res://Art/Minotaur/minotaur.tscn", "weight": 1}
		],
		"path_follow": $Forest2Detect/Path2D/PathFollow2D
	},
	"cave1": {
		"detector": $%Cave1Detect,
		"enemies": [
			{"scene": "res://Art/Bat/Bat.tscn", "weight": 4},
			{"scene": "res://Art/Ghoul/Ghoul.tscn", "weight": 3},
			{"scene": "res://Art/Spider/spider.tscn", "weight": 2},
			{"scene": "res://Art/SlothBear/SlothBear.tscn", "weight": 1}
			],
		"path_follow": %Cave1Detect/Path2D/PathFollow2D
	},
	"cave2": {
		"detector": %Cave2Detect,
		"enemies": [
			{"scene": "res://Art/Wolf/ice_wolf.tscn", "weight": 4},
			{"scene": "res://Art/Siren/siren.tscn", "weight": 3},
			{"scene": "res://Art/BeyRock/Beyrock.tscn", "weight": 2},
			{"scene": "res://Art/Skeledude/skeledude.tscn", "weight": 1}
		],
		"path_follow": $Cave2Detect/Path2D/PathFollow2D
	},
	"swamp1": {
		"detector": %Swamp1Detect,
		"enemies": [
			{"scene": "res://Art/LanternToad/lantern_toad.tscn", "weight": 4},
			{"scene": "res://Art/WaterFish/WaterFish.tscn", "weight": 3},
			{"scene": "res://Art/SlugGuy/slugGuy.tscn", "weight": 2},
			{"scene": "res://Art/Whisps/whisps.tscn", "weight": 1}
		],
		"path_follow": $Swamp1Detect/Path2D/PathFollow2D
	},
	"swamp2": {
		"detector": %Swamp2Detect,
		"enemies": [
			
			{"scene": "res://Art/Popperfish/popperfish.tscn", "weight": 3},
			{"scene": "res://Art/MuckMan/MrMuck.tscn", "weight": 3},
			{"scene": "res://Art/Gator/Gator.tscn", "weight": 3},
			{"scene": "res://Art/Mimic/mimic.tscn", "weight": 1}
		],
		"path_follow": $Swamp2Detect/Path2D/PathFollow2D
		
	},
	"fallenKingdom": {
		"detector": %FallenKingdom,
		"enemies": [
			
			{"scene": "res://Art/StonePiercer/stone_piercer.tscn", "weight": 1},
			{"scene": "res://Art/MushroomBloke/Mushmush.tscn", "weight": 1},
			{"scene": "res://Art/Infected/infected.tscn", "weight": 3}
		],
		"path_follow": $FallenKingdom/Path2D/PathFollow2D
		
	},
	"space": {
		"detector": %Space,
		"enemies": [
			
			{"scene": "res://Art/THEKING/void_worm.tscn", "weight": 3},
			
		],
		"path_follow": $Space/Path2D/PathFollow2D
		
	}
}
var theking_instance = null
var current_area = "forest1" 
var isPaused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_game()
func weighted_random_enemy(enemy_list):
	var total_weight = 0
	for enemy in enemy_list:
		total_weight += enemy["weight"]
	
	var random_value = randf() * total_weight
	var cumulative_weight = 0
	
	for enemy in enemy_list:
		cumulative_weight += enemy["weight"]
		if random_value < cumulative_weight:
			return enemy["scene"]
	
	return enemy_list[0]["scene"]

func spawn_mob():
	var area = area_data[current_area]
	var enemy_list = area["enemies"]
	var path_follow = area["path_follow"]

	if enemy_list.size() == 0:
		return
	if theking_instance == null:
		var enemy_scene_path = weighted_random_enemy(enemy_list)
		if enemy_scene_path == "res://Art/THEKING/void_worm.tscn":
			var enemy_scene = load(enemy_scene_path).instantiate()
			theking_instance = enemy_scene
			path_follow.progress_ratio = randf()
			enemy_scene.global_position = path_follow.global_position
			add_child(enemy_scene)
		else:
			var enemy_scene = load(enemy_scene_path).instantiate()
			path_follow.progress_ratio = randf()
			enemy_scene.global_position = path_follow.global_position
			add_child(enemy_scene)
func _on_timer_timeout() -> void:
	for area_name in area_data.keys():
		var detector = area_data[area_name]["detector"]
		if detector.get_player_enter():
			current_area = area_name
			spawn_mob()
			break
#I BELIEVE DOWN HERE IS THE KING SOLO CHECK

func pause_game():
	pause_menu.global_position = player.global_position
	if isPaused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	isPaused = !isPaused
