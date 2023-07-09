extends CharacterBody2D

var colorIndex = 0
var red;
var green;
var blue;

func _physics_process(delta):
	position = get_viewport().get_mouse_position() - Vector2(20, 20)
	
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
	
	
	$Sprite.set_modulate(Color(red, green, blue, 1))
