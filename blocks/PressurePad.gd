extends CharacterBody2D

var active = false
var queue = false

func _physics_process(delta):
	queue = false
	for i in $TopArea.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name)):
			queue = true
			
	if (!queue):
		active = false
			
	if (queue && !active && !GlobalVariables.overlapping):
		active = true
		GlobalVariables.actuator_state = 1 - GlobalVariables.actuator_state
		
		
	if (GlobalVariables.actuator_state == 1):
		$AnimatedSprite2D.play("Cyan")
	else:
		$AnimatedSprite2D.play("Red")
