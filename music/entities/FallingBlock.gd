extends CharacterBody2D


const SPEED = -20.0
const FALL = 300.0

var state = 0
var xPos = 0
var initialPosition

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isActive = 0

func killPlayer():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()


func _physics_process(delta):
	var volume = (AudioServer.get_bus_peak_volume_left_db(0,0) + AudioServer.get_bus_peak_volume_right_db(0,0)) / 2
	
	var normalized = GlobalVariables.sigmoid((volume + 60), 1.0 / 100.0)
	if (normalized < 0):
		normalized = 0
	elif (normalized > 1):
		normalized = 1
	
	$Sprite2D.scale.x = (0.1 + 0.9 * normalized) * 4
	$Sprite2D.scale.y = (0.1 + 0.9 * normalized) * 4
	
	
	position.x = xPos
	if (isActive):
		return 
	if (state == 0): # Is on floor and preparing to rise
		isActive = 1
		velocity.y = 0
		await get_tree().create_timer(1).timeout
		state = 1
		isActive = 0
	elif (state == 1): # Is rising
		velocity.y = SPEED
		if (is_on_ceiling()):
			state = 2
	elif (state == 2): # Is on ceiling and preparing to fall
		isActive = 1
		velocity.y = 0
		await get_tree().create_timer(1).timeout
		state = 3
		isActive = 0
	else: # Is falling
		velocity.y = FALL
		if (is_on_floor()):
			state = 0
	
	
	killPlayer()
	
	move_and_slide()


func _ready():
	xPos = position.x
	initialPosition = position
	
	$Sprite2D.set_modulate(Color(0.5, 0.5, 0.5, 0.5))
