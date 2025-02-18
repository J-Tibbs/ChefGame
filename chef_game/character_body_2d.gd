extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
var moveSpeed = 400
var attackAnim = false
var fire_once = 1
var health = 100
var canMove = true

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
		pass	
func player_heal(heal_amount) -> void:
	health += heal_amount
	%ProgressBar.Value = health

func setMoving(can) -> void:
	canMove = can
func getMoving() -> bool:
	return canMove
