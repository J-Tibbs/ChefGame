extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
var moveSpeed = 400


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var mouseClick = Input.get_action_raw_strength("MouseClick")
	velocity = direction * moveSpeed
	
	if mouseClick != 0:
		animatedSprite.animation = "Attack"
	else:
		animatedSprite.animation = "default"
	
	move_and_slide()

func _process(delta):
	look_at(get_global_mouse_position())
	rotation_degrees -= 90
