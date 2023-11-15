extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	var volume = (AudioServer.get_bus_peak_volume_left_db(0,0) + AudioServer.get_bus_peak_volume_right_db(0,0)) / 2
	
	var normalized = GlobalVariables.sigmoid((volume + 60), 1.0 / 100.0)
	if (normalized < 0):
		normalized = 0
	elif (normalized > 1):
		normalized = 1
	
	$AnimatedSprite2D.scale.x = 0.1 + 0.9 * normalized
	$AnimatedSprite2D.scale.y = 0.1 + 0.9 * normalized
