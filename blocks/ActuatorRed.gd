extends CharacterBody2D

var overlapping = 0
var overlapped = 0

func _physics_process(delta):
	if (GlobalVariables.actuator_state == 0):
		$AnimatedSprite2D.play("Active")
		$CollisionShape2D.disabled = false
	else:
		$AnimatedSprite2D.play("Inactive")
		$CollisionShape2D.disabled = true
		
	overlapped = 0
	for i in $Area2D.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name) || GlobalVariables.is_Proxy(i.name)):
			overlapped = 1
		
	if (overlapped && GlobalVariables.actuator_state == 1):
		if (overlapping == 0):
			overlapping = 1
			GlobalVariables.overlapping += 1
	else:
		if (overlapping == 1):
			overlapping = 0
			GlobalVariables.overlapping -= 1
