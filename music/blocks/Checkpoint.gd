extends CharacterBody2D

var enabled = false
var latency = false

func _physics_process(delta):
	if (GlobalVariables.CheckpointTriggered):
		# print("CHECKPOINT RESET ", position)
		enabled = false
	
	enabled = enabled or latency
	
	if (latency):
		latency = false
		GlobalVariables.CheckpointTriggered = false
		
	for object in $Area2D.get_overlapping_bodies():
		if (object.name.substr(0, 6) == "Player"):
			# print("CHECKPOINT TRIGGERED ", position)
			latency = true
			GlobalVariables.CheckpointTriggered = true
			break
	
	
	
	if (enabled):
		$Sprite2D.set_modulate(Color(0, 1, 0, 1))
		GlobalVariables.CheckPointPosition = position
	else:
		$Sprite2D.set_modulate(Color(0, 0, 1, 1))
