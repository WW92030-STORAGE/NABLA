extends CharacterBody2D

var dx
var dy

var dir
var lineAreas

var pos

var sticky = false
var retracting

func _ready():
	dx = [01, 00, -1, 00]
	dy = [00, 01, 00, -1]
	
	pos = global_position
	
	dir = floor((self.rotation_degrees + 45) / 90)
	while (dir < 0):
		dir += 40
	
	dir = fmod(dir, 4)
	# print(dir, " ", position.x, " ", position.y)
	
	lineAreas = [$FrontArea, $FrontArea2, $FrontArea3, $FrontArea4, $FrontArea5, $FrontArea6, $FrontArea7, $FrontArea8, $FrontArea9, $FrontArea10, $FrontArea11, $FrontArea12, $FrontArea13, $FrontArea14]
	
	sticky = get_meta("sticky")
# When powered the piston is able to move.
# The piston can only move if the following conditions are satisfied:
# 1. There is a line of at most 12 pushable blocks in front of the piston head
# 2. The block succeeding the line is air. Entities cannot be pushed.
# I might add portals or something for entities later.

var power = 0
var setpower = 0
var line
var blocked

var extended = false

func _physics_process(delta):
	
	if (position != pos):
		position = pos
		
	if (extended):
		if (len($FrontArea.get_overlapping_bodies()) > 1):
			extended = false
			$PistonHead.global_position = position
			$PistonHeadCollision.global_position = position
			return
		
	if (extended):
		$PistonHead.global_position = position + Vector2(16 * dx[dir], 16 * dy[dir])
		$PistonHeadCollision.global_position = position + Vector2(16 * dx[dir], 16 * dy[dir])
	else:
		$PistonHead.global_position = position
		$PistonHeadCollision.global_position = position
		retracting = false
		
	power = 1 if setpower > 0 else 0
	
	setpower = 0
	
	for object in $RedstonePistonArea.get_overlapping_areas():
		if (object.name.substr(0, 12) == "RedstoneWire"):
			setpower = max(setpower, object.find_parent("*").power)
		elif (object.name.substr(0, 12 + 1) == "RedstoneBlock"):
			setpower = max(setpower, 15)
		elif (object.name.substr(0, 21) == "RedstoneDiodeOutArea"):
			setpower = max(setpower, object.find_parent("*").power)
		elif (object.name.substr(0, 23) == "RedstoneInverterOutArea"):
			setpower = max(setpower, object.find_parent("*").power)
		elif (object.name.substr(0, 17) == "RedstonePowerable"):
			setpower = max(setpower, object.find_parent("*").power)
	
	$PistonBase.set_modulate(Color(power, power, power, 1))
	
	if (power == 0):
		$PistonHead.global_position = position
		$PistonHeadCollision.global_position = position
		if (sticky and !retracting && extended):
			retracting = true
			# print("STICKY PISTON RETRACTING ", position)
			
			for object in $FrontArea2.get_overlapping_bodies():
				if (GlobalVariables.piston_Movable(object.name)):
					object.global_position = object.global_position - Vector2(16 * dx[dir], 16 * dy[dir])
				if (object.name.substr(0, 14) == "RedstonePiston" || object.name.substr(0, 12) == "StickyPiston"):
					# print("RETRACTION RETRACTING PISTON...", object.global_position)
					if (!object.extended):
						object.pos = object.pos - Vector2(16 * dx[dir], 16 * dy[dir])
						object.global_position = object.global_position - Vector2(16 * dx[dir], 16 * dy[dir])
						object.extended = false
					print(object.global_position)
		
		extended = false
		
	if (extended):
		return
	
	if (power == 1):
		blocked = false
		var lineactive = true
		line = []
		
		for area in lineAreas:
			
			lineactive = false
			
			for object in area.get_overlapping_bodies():
				if (object.name.substr(0, 14) == "RedstonePiston" || object.name.substr(0, 12) == "StickyPiston"):
					print("DETECTED PISTON")
					if (!object.extended):
						lineactive = true
						line.append(object)
						# print("PISTON MOVABLE ", object.name, object.global_position)
						continue
					else:
						blocked = true
						# print("PISTON IMMOVABLE ", object.name, object.global_position)
						break
						
						
				if (GlobalVariables.piston_Movable(object.name)):
					lineactive = true
					line.append(object)
					# print("PISTON MOVABLE ", object.name, object.global_position)
					continue
				elif (GlobalVariables.is_Block(object.name)):
					blocked = true
					# print("PISTON IMMOVABLE ", object.name, object.global_position)
					break
				else:
					if (GlobalVariables.is_Entity(object.name)):
						blocked = true
						# print("PISTON ENTITY", object.name)
						break
			
			if (len(line) > 16 or !lineactive):
				break
	
		if (len(line) <= 12 and !blocked):
			for i in range(len(line)):
				var index = len(line) - 1 - i
				if (line[index].name.substr(0, 14) == "RedstonePiston" || line[index].name.substr(0, 12) == "StickyPiston"):
					line[index].pos += Vector2(dx[dir] * 16, dy[dir] * 16)
				line[index].global_position += Vector2(dx[dir] * 16, dy[dir] * 16)
			extended = true
			# print("PISTON EXTENSION ", position)
		else:
			# print("INVALID PISTON MOVEMENT", len(line), blocked)
			extended = false
