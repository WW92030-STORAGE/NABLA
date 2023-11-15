extends CharacterBody2D


func _physics_process(delta):
	
	for i in $TopArea.get_overlapping_bodies():
		if (GlobalVariables.is_Entity(i.name)):
			$AnimatedSprite2D.play("break")
			await get_tree().create_timer(1).timeout
			queue_free()
		
