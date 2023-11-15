extends CharacterBody2D

var active = false
var queue = false

var power = 0

func _physics_process(delta):
	queue = false
	for i in $PressureArea2D.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name) || GlobalVariables.is_Proxy(i.name) || GlobalVariables.piston_Movable(i.name)):
			queue = true
			
	if (!queue):
		active = false
			
	if (queue && !active):
		active = true
	
	power = 15 if active else 0
	
	var p = power / 15
	
	$Sprite2D.set_modulate(Color(p, p, p, 1))
