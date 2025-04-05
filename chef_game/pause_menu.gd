extends Control

@onready var main = $"../"
@onready var player = get_node("/root/Node2D/Player")

func _ready() -> void:
	%HowToPlay.visible = false
	%PauseBox.visible = true
	
func _on_resume_pressed() -> void:
	main.pause_game()



func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_how_play_pressed() -> void:
	%PauseBox.visible = false
	%HowToPlay.visible = true
	
func remove_howto():
	%PauseBox.visible = true
	%HowToPlay.visible = false
