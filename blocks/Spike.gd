extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_death():
	for i in $Area2D.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()

func _physics_process(delta):
	handle_death()
