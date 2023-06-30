@tool
extends PanelContainer

@export var locked = false:
	set = set_locked
@export var level_num = 1:
	set = set_level

@onready var lock = $MarginContainer/Lock
@onready var label = $Label

func _ready():
	locked = level_num > (GlobalVariables.load_data()).levels
	
	var resource = load("res://sprites/ui/levels/" + str(level_num) + ".png")
	label.texture = resource

func set_locked(value):
	locked = value
	if not is_inside_tree():
		await ready
	lock.visible = value
	label.visible = not value

func set_level(value):
	level_num = value
	if not is_inside_tree():
		await ready
	var resource = load("res://sprites/ui/levels/" + str(level_num) + ".png")
	label.texture = resource


func _on_gui_input(event):
	if locked:
		return
	if event is InputEventMouseButton and event.pressed:
		print("ENTERING LEVEL...", level_num)
		
		var data = GlobalVariables.load_data();
		data.CurrentLevel = level_num
		GlobalVariables.save_data(data)
		
		get_tree().change_scene_to_file("res://levels/level_" + str(level_num) + ".tscn")
	


func _on_mouse_entered():
	GlobalVariables.CurrentSelectedLevel = level_num


func _on_mouse_exited():
	GlobalVariables.CurrentSelectedLevel = -1
