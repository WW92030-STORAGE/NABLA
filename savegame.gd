extends Resource
class_name SaveData

var levels
var Enemies # -1 = incomplete. This is appended when a level is began.

var CurrentLevel # -1 = menu screens
var CurrentEnemies # Enemies killed in current level

func _init():
	levels = 0
	Enemies = []
	CurrentLevel = -1
	CurrentEnemies = []
