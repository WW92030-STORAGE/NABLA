extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = -1
var switched = 0
var collisions = 0
var EnemyRam = 0

func killPlayer():
	for i in $EnemyProtectionArea2D.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()

func destroy():
	if (collisions >= 32):
		queue_free()
	
	for i in $EnemyProtectionArea2D.get_overlapping_bodies():
		if (i.name.substr(0, 5) == "Spike"):
			queue_free()
		if (i.name.substr(0, 12) == "FallingBlock"):
			queue_free()

func _physics_process(delta):
	if (GlobalVariables.RESET_SCENE > 0):
		queue_free()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = SPEED * direction
	
	if is_on_wall() && !switched:
		for object in $EnemyProtectionBlock2D.get_overlapping_bodies():
			if (object.name.substr(0, 11) == "NormalEnemy"):
				print("COLLISION WITH DESTROYABLE ENEMY")
				EnemyRam = 2
				break
		
		if (EnemyRam <= 0):
			direction *= -1
			switched = 2
			collisions += 1
		
	if (switched > 0):
		switched -= 1
		
	if (EnemyRam > 0):
		EnemyRam -= 1
		
	killPlayer()
	destroy()

	move_and_slide()
	
	if (velocity.x < 0):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	if (position.y > GlobalVariables.BAR_LOWER || position.y < GlobalVariables.BAR_UPPER):
		queue_free()

func _ready():
	print_debug("SPAWNING ENEMY PROTECTION")
