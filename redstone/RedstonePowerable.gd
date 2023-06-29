extends CharacterBody2D

var power = 5
var areas

var textureid

var delay = 0

func _process(delta):
	var setpower = 0
	
	
	textureid = 0
	for i in range(4):
		var overlap = false
		for object in areas[i].get_overlapping_areas():
			if (GlobalVariables.redstone_Block_Connected(object.name)):
				overlap = true
			if (object.name.substr(0, 14) == "PressureArea2D"):
				overlap = false
				print(object.name)
			if (object.name.substr(0, 21) == "RedstoneDiodeOutArea"):
				setpower = max(setpower, object.find_parent("*").power)
			elif (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
				setpower = max(setpower, object.find_parent("*").power)
			
		if (overlap):
			textureid += (1<<i)
	
	power = setpower
			
	# textureid = randi() % 16
	
	var row = (textureid>>2) + 1
	var col = (textureid % 4) + 1
	
	# print(position, textureid, row, col)
	
	var resource = load("res://sprites/Redstone/thicknocenter/row-" + str(row) + "-column-" + str(col) + ".png")
	
	var pcolor = power / 15.0
	
	# $Sprite2D.texture = resource
	$Sprite2D.texture = resource
	$Sprite2D.set_modulate(Color(pcolor, pcolor, pcolor, 1))
	$Corners.set_modulate(Color(pcolor, pcolor, pcolor, 1))

func _physics_process(delta):
	pass
	
func _ready():
	areas = [$RedstonePowerableR, $RedstonePowerableD, $RedstonePowerableL, $RedstonePowerableU]
