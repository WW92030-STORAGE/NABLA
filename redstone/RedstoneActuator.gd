extends CharacterBody2D

var power = 0
var setpower = 0
var overlapped = 0

func _physics_process(delta):
	power = setpower
	
	for object in $RedstoneActuatorX.get_overlapping_areas():
		if (object.name.substr(0, 12) == "RedstoneWire" || object.name.substr(0, 20) == "RedstoneDiodeOutArea"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		if (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			setpower = 15
		elif (object.name.substr(0, 14) == "PressureSensor"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		
	if (power > 0 && overlapped == 0):
		$AnimatedSprite2D.play("Active")
		$CollisionShape2D.disabled = false
	else:
		$AnimatedSprite2D.play("Inactive")
		$CollisionShape2D.disabled = true
	
	
	overlapped = 0
	for i in $Area2D.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name) || GlobalVariables.is_Proxy(i.name)):
			overlapped = 1
