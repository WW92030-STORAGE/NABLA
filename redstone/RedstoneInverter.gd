extends CharacterBody2D


var power = 0

func _physics_process(delta):
	pass

func _process(delta):
	for object in $RedstoneInverterInArea.get_overlapping_areas():
		power = 0
		if (object.name.substr(0, 12) == "RedstoneWire" || object.name.substr(0, 20) == "RedstoneDiodeOutArea"):
			power = 0 if (object.find_parent("*").power > 0) else 15
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			power = 0
		elif (object.name.substr(0, 14) == "PressureSensor"):
			power = 0 if (object.find_parent("*").power > 0) else 15
		elif (object.name.substr(0, 17) == "RedstonePowerable"):
			power = 0 if (object.find_parent("*").power > 0) else 15
		
		var p = power / 15
		$Indicator.set_modulate(Color(p, p, p, 1))
			
