extends CharacterBody2D


var power = 0
var power0 = 0

func _physics_process(delta):
	pass

func _process(delta):
	for object in $RedstoneDiodeInArea.get_overlapping_areas():
		if (object.name.substr(0, 12) == "RedstoneWire" || object.name.substr(0, 20) == "RedstoneDiodeOutArea"):
			power = 15 if (object.find_parent("*").power > 0) else 0
		if (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
			power = 15 if (object.find_parent("*").power > 0) else 0
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			power = 15
		elif (object.name.substr(0, 14) == "PressureSensor"):
			power = 15 if (object.find_parent("*").power > 0) else 0
		elif (object.name.substr(0, 17) == "RedstonePowerable"):
			power = 15 if (object.find_parent("*").power > 0) else 0
		
		var p = power / 15
		$Indicator.set_modulate(Color(p, p, p, 1))
			
