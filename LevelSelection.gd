extends MarginContainer

var isdir = 1
var direction = 0

@onready var LEVELS = $VBoxContainer/HBoxContainer/Control/HBoxContainer
var initpos

# Called when the node enters the scene tree for the first time.
func _ready():
	initpos = LEVELS.global_position + Vector2(70, 100)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	isdir = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GlobalVariables.CurrentSelectedLevel < 0):
		$VBoxContainer/TITLE.text = "【SELECT LEVEL】"
	else:
		var name = GlobalVariables.LEVEL_NAMES[GlobalVariables.CurrentSelectedLevel]
		var diff = GlobalVariables.DIFFICULTIES[GlobalVariables.CurrentSelectedLevel]
		$VBoxContainer/TITLE.text = "【" + name + " - " + diff + "】"


func _physics_process(delta):
	direction = Input.get_axis("ui_left", "ui_right")
	if (direction == 1 && isdir == 0):
		isdir = 1
		print("NEXT PAGE")
		GlobalVariables.MENU_SCREEN = (GlobalVariables.MENU_SCREEN + 1) % GlobalVariables.NUM_MENUS
		print(GlobalVariables.MENU_SCREEN)
	elif (direction == -1 && isdir == 0):
		isdir = 1
		print("PREV PAGE")
		GlobalVariables.MENU_SCREEN = (GlobalVariables.MENU_SCREEN + GlobalVariables.NUM_MENUS - 1) % GlobalVariables.NUM_MENUS
		print(GlobalVariables.MENU_SCREEN)
	elif (direction == 0):
		isdir = 0
	
	LEVELS.global_position = initpos - Vector2(504 * GlobalVariables.MENU_SCREEN, 0)
