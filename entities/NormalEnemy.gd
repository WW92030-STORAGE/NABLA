extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = -1
var switched = 0
var bounced = 0

func killPlayer():
	for i in $SideArea.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()

func destroy():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name.substr(0, 5) == "Spike"):
			queue_free()
		if (i.name.substr(0, 6) == "Roller"):
			queue_free()
		if (i.name.substr(0, 16) == "EnemyProtection"):
			queue_free()
	
	for i in $TopArea.get_overlapping_bodies():
		if (i.name == "Player"):
			queue_free()
		if (i.name.substr(0, 12) == "FallingBlock"):
			queue_free()
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if (is_on_floor()):
		if (bounced > 0):
			bounced -= 1
		velocity.x = SPEED * direction
	elif (bounced == 0):
		velocity.x = 0
	
	if is_on_wall() && !switched:
		direction *= -1
		switched = 2
		
	if (switched > 0):
		switched -= 1
		
	if (velocity.x < 0):
		$AnimatedSprite2D.flip_h = true
	elif (velocity.x > 0):
		$AnimatedSprite2D.flip_h = false
		
	if (position.y > GlobalVariables.BAR_LOWER || position.y < GlobalVariables.BAR_UPPER):
		queue_free()
		
	killPlayer()
	destroy()

	move_and_slide()
