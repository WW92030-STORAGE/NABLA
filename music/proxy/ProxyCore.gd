extends CharacterBody2D

var dx = [1, 0, -1, 0]
var dy = [0, 1, 0, -1]

var areas
var faces

var SX
var SY

var DEBUG = 0

func _ready():
	areas = [$RIGHT, $DOWN, $LEFT, $UP]
	faces = [$TopArea, $LeftArea, $BottomArea, $RightArea]
	SX = position.x
	SY = position.y
	GlobalVariables.PROXY_SPAWN = Vector2(SX, SY)
	

func _process(delta):
	GlobalVariables.PROXY_POSITION = global_position
	if (GlobalVariables.PROXY_COOL == 4):
		if (DEBUG):
			print("CORE DATA COLLECTING")
		if (GlobalVariables.PROXY_DIR < 4):
			if (GlobalVariables.PROXY_DIR == 1 && position.y > GlobalVariables.BAR_LOWER):
				GlobalVariables.PROXY_OVERLAP += 1
			elif (GlobalVariables.PROXY_DIR == 3 && position.y < GlobalVariables.BAR_UPPER):
				GlobalVariables.PROXY_OVERLAP += 1
			for i in areas[GlobalVariables.PROXY_DIR].get_overlapping_bodies():
				if (i.name.substr(0, 9) != "ProxyCore" && i.name.substr(0, 10) != "ProxyBlock"):
					print("PROXY OVERLAP ", i.name)
					GlobalVariables.PROXY_OVERLAP += 1
		else:
			pass
		
		for i in $TopArea.get_overlapping_bodies():
			if (GlobalVariables.is_Physical_Entity(i.name)):
				GlobalVariables.PROXY_IMMOBILE += 1
	
	elif (GlobalVariables.PROXY_COOL == 3):
		if (GlobalVariables.PROXY_OVERLAP == 0 && GlobalVariables.PROXY_IMMOBILE == 0):
			if (GlobalVariables.PROXY_DIR < 4):
				position.x += 16 * dx[GlobalVariables.PROXY_DIR]
				position.y += 16 * dy[GlobalVariables.PROXY_DIR]
				$AnimatedSprite2D.play("default")
				
		elif (GlobalVariables.PROXY_IMMOBILE > 0):
			$AnimatedSprite2D.play("Invalid")
	
	
