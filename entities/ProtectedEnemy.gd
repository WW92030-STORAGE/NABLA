extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = -1
var switched = 0

var climb = 0
var climblower = 0
var climbupper = 0
var climbed = 0

var bounced = 0

func killPlayer():
	for i in $SideArea.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()
			
func die():
	var data = GlobalVariables.load_data()
	var string = str(self).substr(0, str(self).find(":"))
	data.CurrentEnemies.append(string)
	print(data.CurrentEnemies)
	GlobalVariables.save_data(data)
	
	
	var x = position.x
	var y = position.y
	print_debug(x, y)
	var protection = load("res://entities/EnemyProtection.tscn")
	var entity = protection.instantiate()
	entity.position.x = x
	entity.position.y = y + 8
	get_tree().get_root().add_child(entity)
	queue_free()
	

func destroy():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name.substr(0, 5) == "Spike"):
			die()
		if (i.name.substr(0, 6) == "Roller"):
			die()
	
	for i in $TopArea.get_overlapping_bodies():
		if (i.name == "Player"):
			die()
		if (i.name.substr(0, 12) == "FallingBlock"):
			die()

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
	
	if is_on_wall() && is_on_floor():
		climbupper = 0
		climblower = 0
		for i in $Area2D.get_overlapping_bodies():
			if (GlobalVariables.is_Block(i.name)):
				climblower = 1
		if ($ClimbArea.get_overlapping_bodies().size() > 0):
			climbupper = 1
			
		climb = climblower && !climbupper
		# print_debug(climblower, climbupper, climb)
		
		
		if (climb && climbed <= 0):
			position.y -= 16
			climbed = 2
		elif !switched:
			direction *= -1
			switched = 2
		
	if (switched > 0):
		switched -= 1
	if (climbed > 0):
		climbed -= 1
		
	if (velocity.x < 0):
		$AnimatedSprite2D.flip_h = true
	elif (velocity.x > 0):
		$AnimatedSprite2D.flip_h = false
		
	if (position.y > GlobalVariables.BAR_LOWER || position.y < GlobalVariables.BAR_UPPER):
		die()
		
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
	
