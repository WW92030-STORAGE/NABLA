extends CharacterBody2D


var state = 0
var isActive = false

func fire():
	var theta = transform.get_rotation()
	# print_debug("LAUNCHER ANGLE = ", theta)
	var x = position.x - 16 * cos(theta)
	var y = position.y - 16 * sin(theta)
	var protection = load("res://entities/Roller.tscn")
	var entity = protection.instantiate()
	entity.position.x = x
	entity.position.y = y
	entity.velocity.x = -300 * cos(theta)
	entity.velocity.y = -300 * sin(theta)
	entity.switched = 16 * randi_range(0, 1)
	get_tree().get_root().add_child(entity)
	entity.name = "Roller_" + entity.name
	print("FIRED ", entity.name)

func _process(delta):
	if (isActive):
		return
	if (state == 0):
		isActive = 1
		await get_tree().create_timer(4).timeout
		print_debug("CUEING...")
		isActive = 0
	elif (state == 1):
		$AnimatedSprite2D.play("cue")
	elif (state == 2):
		isActive = 1
		await get_tree().create_timer(1).timeout
		print_debug("FIRING...")
		isActive = 0
	elif (state == 3):
		fire()
		$AnimatedSprite2D.play("idle")
		
	state = (state + 1) % 4
		
