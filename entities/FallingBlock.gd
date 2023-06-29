extends CharacterBody2D


const SPEED = -20.0
const FALL = 300.0

var state = 0
var xPos = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var isActive = 0

func killPlayer():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()


func _physics_process(delta):
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
