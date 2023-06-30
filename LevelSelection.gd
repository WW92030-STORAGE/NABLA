extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GlobalVariables.CurrentSelectedLevel < 0):
		$VBoxContainer/TITLE.text = "【SELECT LEVEL】"
	else:
		var name = GlobalVariables.LEVEL_NAMES[GlobalVariables.CurrentSelectedLevel]
		var diff = GlobalVariables.DIFFICULTIES[GlobalVariables.CurrentSelectedLevel]
		$VBoxContainer/TITLE.text = "【" + name + " - " + diff + "】"
