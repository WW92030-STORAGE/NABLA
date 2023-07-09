extends CharacterBody2D


const SPEED = 40.0
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

func remove():
	var data = GlobalVariables.load_data()
	var string = str(self).substr(0, str(self).find(":"))
	data.CurrentEnemies.append(string)
	print(data.CurrentEnemies)
	GlobalVariables.save_data(data)
	queue_free()

func destroy():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name.substr(0, 5) == "Spike"):
			remove()
		if (i.name.substr(0, 6) == "Roller"):
			remove()
		if (i.name.substr(0, 15) == "EnemyProtection"):
			print("COLLISION WITH ENEMY PROTECTION")
			remove()
	
	for i in $TopArea.get_overlapping_bodies():
		if (i.name == "Player"):
			remove()
		if (i.name.substr(0, 12) == "FallingBlock"):
			remove()
			
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
		remove()
		
	killPlayer()
	destroy()

	move_and_slide()

func _ready():
	var string = str(self).substr(0, str(self).find(":"))
	
	var destroyed = false
	var data = GlobalVariables.load_data()
	for i in data.CurrentEnemies:
		if (i == string):
			destroyed = true
			break
	
	
	if (destroyed):
		queue_free()
				
