extends AnimatedSprite2D

@onready var animatedSprite = self
@onready var player = get_node("/root/Node2D/Player")
var state
var enemyInRange
var attackingEnemy
var damage = 5
var attackAnim = false
var enemies_in_area = []


func _ready():
	animatedSprite.play("Blank")
#@export var animated_sprite2d: AnimatedSprite2D
func _physics_process(delta):
	
	var mouseClick = Input.is_action_just_pressed("MouseClick")
	
	
	if mouseClick and not attackAnim:
		attackAnim = true
		animatedSprite.play("Attack")
		attack()

		
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Enemies"):
		enemies_in_area.append(body)
			
func _on_animated_sprite_2d_animation_finished() -> void:
	if animatedSprite.animation == "Attack":
		attackAnim = false
		animatedSprite.play("Blank")
	else:
		print("Anim sprite not found: further attack")

	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemies") and body in enemies_in_area:
		enemies_in_area.erase(body)
		
		
func attack():
	if enemies_in_area.size() > 0:
		for enemy in enemies_in_area:
			if enemy.has_method("_attacked"):
				enemy._attacked(self.global_position, damage)
