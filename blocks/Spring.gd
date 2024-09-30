extends CharacterBody2D

var theta
var sx
var sy

var momentum = 500

func _ready():
	theta = get_transform().get_rotation()
	sx = cos(theta)
	sy = sin(theta)

func _on_area_2d_body_entered(i):
	var bounce = 0
	print_debug(i.name)
	if (i.name == "Player"):
		bounce = 1
	if (i.name.substr(0, 11) == "NormalEnemy"):
		bounce = 2
	if (i.name.substr(0, 14) == "ProtectedEnemy"):
		bounce = 2
		
	if (bounce > 0):
		i.bounced = 2
		print_debug("LAUNCH")
		i.velocity.x += momentum * sx
		i.velocity.y += momentum * sy
		
	if (bounce == 2):
		if (i.velocity.x < 0):
			i.direction = -1
		else:
			i.direction = 1
