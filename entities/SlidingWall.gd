extends CharacterBody2D

@export var speed = 300

func killPlayer():
	
	for i in $Area2D.get_overlapping_bodies():
		if (i.name == "Player"):
			GlobalVariables.resetCurrentScene()
	
func _ready():
	if (GlobalVariables.CheckPointPosition != null && GlobalVariables.PLAYER_SPAWN != null):
		position = position + Vector2(GlobalVariables.CheckPointPosition.x - GlobalVariables.PLAYER_SPAWN.x, 0)
	
	
func _physics_process(delta):
	position.x += speed * delta
	position.y = GlobalVariables.PLAYER_POSITION.y
	killPlayer();
