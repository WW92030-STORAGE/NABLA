extends CharacterBody2D

var colorIndex = 0
var red;
var green;
var blue;

func _physics_process(delta):
	
	var triggered = false
	for object in $Area2D.get_overlapping_bodies():
		if (object.name.substr(0, 6) == "Player"):
			triggered = true
			break
	
	
	if (triggered):
		var data = GlobalVariables.load_data()
		print("CURRENT LEVEL ", data.CurrentLevel)
	
		data.levels = max(data.levels, data.CurrentLevel + 1)
		while (len(data.Enemies) <= data.CurrentLevel) :
			data.Enemies.append(-1)
			data.CurrentEnemies = 0
	
		print("COMPLETED LEVEL ", data.CurrentLevel, " / ", data.levels)
		data.CurrentLevel = -1
		GlobalVariables.CurrentSelectedLevel = -1
		GlobalVariables.CheckPointPosition = null
		GlobalVariables.save_data(data)
		get_tree().change_scene_to_file("res://LevelSelection.tscn")
	
	colorIndex += 16
	colorIndex = colorIndex % (6 * 256)
	
	var index = int(colorIndex / 256)
	var val = (colorIndex / 256.0) - index
	
	if (index == 0):
		red = 1
		blue = 0
		green = val
	elif (index == 1):
		red = 1 - val
		green = 1
		blue = 0
	elif (index == 2):
		red = 0
		green = 1
		blue = val
	elif (index == 3):
		red = 0
		green = 1 - val
		blue = 1
	elif (index == 4):
		red = val
		green = 0
		blue = 1
	elif (index == 5):
		red = 1
		green = 0
		blue = 1 - val
	else:
		red = 1
		green = 1
		blue = 1
	
	
	$Sprite2D.set_modulate(Color(red, green, blue, 1))
