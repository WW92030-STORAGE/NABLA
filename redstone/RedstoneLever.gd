extends CharacterBody2D

var active = false
var queue = false

var power = 0
var setpower = 0

func _physics_process(delta):
	power = setpower
	queue = false
	for i in $PressureArea2D.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name) || GlobalVariables.is_Proxy(i.name) || GlobalVariables.piston_Movable(i.name)):
			queue = true
			
	if (!queue):
		active = false
			
	if (queue && !active):
		active = true
		setpower = 15 - setpower
	
	var p = power / 15
	
	$Sprite2D.set_modulate(Color(p, p, p, 1))
