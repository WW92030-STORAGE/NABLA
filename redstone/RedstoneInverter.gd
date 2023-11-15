extends CharacterBody2D


var power = 0
var setpower = 0

func _physics_process(delta):
	power = setpower
	setpower = 15
	
	for object in $RedstoneInverterInArea.get_overlapping_areas():
		
		if (object.name.substr(0, 12) == "RedstoneWire" || object.name.substr(0, 20) == "RedstoneDiodeOutArea"):
			setpower = 0 if (object.find_parent("*").power > 0) else 15
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			setpower = 0
		elif (object.name.substr(0, 14) == "PressureSensor"):
			setpower = 0 if (object.find_parent("*").power > 0) else 15
		elif (object.name.substr(0, 17) == "RedstonePowerable"):
			setpower = 0 if (object.find_parent("*").power > 0) else 15
		
	var p = power / 15
	$Indicator.set_modulate(Color(p, p, p, 1))
			
