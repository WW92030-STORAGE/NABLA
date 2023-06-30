extends CharacterBody2D

var power = 0
var areas

var textureid

var delay = 0

func _process(delta):
	var setpower = 0
	
	
	textureid = 0
	for i in range(4):
		var overlap = false
		for object in areas[i].get_overlapping_areas():
			if (GlobalVariables.is_Redstone_Transmission(object.name)):
				overlap = true
			if (object.name.substr(0, 14) == "RedstonePiston"):
				overlap = true
			if (object.name.substr(0, 12) == "RedstoneWire"):
				setpower = max(setpower, object.find_parent("*").power - 1)
			elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
				setpower = 15
			elif (object.name.substr(0, 21) == "RedstoneDiodeOutArea"):
				setpower = max(setpower, object.find_parent("*").power)
			elif (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
				setpower = max(setpower, object.find_parent("*").power)
			elif (object.name.substr(0, 17) == "RedstonePowerable"):
				setpower = max(setpower, object.find_parent("*").power)
			
		if (overlap):
			textureid += (1<<i)
	
	for object in $RedstoneWireX.get_overlapping_areas():
		if (object.name.substr(0, 14) == "PressureSensor"):
			setpower = max(setpower, object.find_parent("*").power)
	
	power = setpower
			
	# textureid = randi() % 16
	
	var row = (textureid>>2) + 1
	var col = (textureid % 4) + 1
	
	# print(position, textureid, row, col)
	
	var resource = load("res://sprites/Redstone/individual/row-" + str(row) + "-column-" + str(col) + ".png")
	
	var pcolor = power / 15.0
	
	# $Sprite2D.texture = resource
	$Sprite2D.texture = resource
	$Sprite2D.set_modulate(Color(pcolor, pcolor, pcolor, 1))
	

func _physics_process(delta):
	pass
	
func _ready():
	areas = [$RedstoneWireR, $RedstoneWireD, $RedstoneWireL, $RedstoneWireU]
