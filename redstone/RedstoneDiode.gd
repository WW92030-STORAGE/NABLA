extends CharacterBody2D


var power = 0
var latency = []
var setpower = 0

var delay = 8

func _ready():
	for i in range(delay):
		latency.append(0)

func _physics_process(delta):
	pass

func _process(delta):
	
	power = latency[0]
	for i in range(delay - 1):
		latency[i] = latency[i + 1]
	
	latency[delay - 1] = setpower
		
	for object in $RedstoneDiodeInArea.get_overlapping_areas():
		if (object.name.substr(0, 12) == "RedstoneWire" || object.name.substr(0, 20) == "RedstoneDiodeOutArea"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		if (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			setpower = 15
		elif (object.name.substr(0, 14) == "PressureSensor"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		elif (object.name.substr(0, 17) == "RedstonePowerable"):
			setpower = 15 if (object.find_parent("*").power > 0) else 0
		
		var p = power / 15
		$Indicator.set_modulate(Color(p, p, p, 1))
			
