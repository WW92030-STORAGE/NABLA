extends CharacterBody2D

var dx = [1, 0, -1, 0]
var dy = [0, 1, 0, -1]

var areas
var faces

var DEBUG = 0

func _ready():
	areas = [$RIGHT, $DOWN, $LEFT, $UP]
	faces = [$TopArea, $LeftArea, $BottomArea, $RightArea]
	
func _process(delta):
	if (GlobalVariables.PROXY_COOL == 4):
		if (DEBUG):
			print("BLOCK DATA COLLECTING")
		if (GlobalVariables.PROXY_DIR < 4):
			for i in areas[GlobalVariables.PROXY_DIR].get_overlapping_bodies():
				if (i.name.substr(0, 9) != "ProxyCore" && i.name.substr(0, 10) != "ProxyBlock"):
					print("PROXY OVERLAP ", i.name)
					GlobalVariables.PROXY_OVERLAP += 1
		else:
			var disp = global_position - GlobalVariables.PROXY_POSITION
			var dis2 = GlobalVariables.rotate(disp, GlobalVariables.PROXY_ROTATION_STEPS)
			$RotationArea.global_position = dis2 + GlobalVariables.PROXY_POSITION
			if (DEBUG):
				print("DISP ", disp)
				print("ROTATED ", dis2)
				print("SOLVED ", dis2 + GlobalVariables.PROXY_POSITION)
			
			
			for i in $RotationArea.get_overlapping_bodies():
				if (i.name.substr(0, 9) != "ProxyCore" && i.name.substr(0, 10) != "ProxyBlock"):
					GlobalVariables.PROXY_OVERLAP += 1
		
		for i in $TopArea.get_overlapping_bodies():
			if (GlobalVariables.is_Physical_Entity(i.name)):
				GlobalVariables.PROXY_IMMOBILE += 1
				
	
	elif (GlobalVariables.PROXY_COOL == 3):
		if (GlobalVariables.PROXY_OVERLAP == 0 && GlobalVariables.PROXY_IMMOBILE == 0):
			if (GlobalVariables.PROXY_DIR < 4):
				position.x += 16 * dx[GlobalVariables.PROXY_DIR]
				position.y += 16 * dy[GlobalVariables.PROXY_DIR]
				$RotationArea/AnimatedSprite2D.play("default")
			else:
				var disp = global_position - GlobalVariables.PROXY_POSITION
				var dis2 = GlobalVariables.rotate(disp, GlobalVariables.PROXY_ROTATION_STEPS)
				global_position = dis2 + GlobalVariables.PROXY_POSITION
				
				disp = global_position - GlobalVariables.PROXY_POSITION
				dis2 = GlobalVariables.rotate(disp, GlobalVariables.PROXY_ROTATION_STEPS)
				$RotationArea.global_position = dis2 + GlobalVariables.PROXY_POSITION
				$RotationArea/AnimatedSprite2D.play("default")
				# $AnimatedSprite2D.play("default")
		elif (GlobalVariables.PROXY_DIR > 3):
			$RotationArea/AnimatedSprite2D.play("Invalid")
		elif (GlobalVariables.PROXY_IMMOBILE > 0):
			# $AnimatedSprite2D.play("Invalid")
			pass
	
	
