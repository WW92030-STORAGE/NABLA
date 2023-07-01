extends Node

var actuator_state = 0
var overlapping = 0

var PLAYER_GRAV = 1
var CETERA_GRAV = 1

var PLAYER_SPAWN = Vector2(0, 0)
var PROXY_SPAWN = Vector2(0, 0)

var PROXY_POSITION = Vector2(0, 0)
var PLAYER_ACTIVE = 1
var PROXY_ACTIVE = 0

var PROXY_OVERLAP = 0
var PROXY_DIR = 0
var PROXY_COOL = 0
var PROXY_CLOCK = 1.0 / 20.0
var PROXY_IMMOBILE = 0

var PROXY_ROTATION_STEPS = 1

var BAR_LOWER = 16 * 10
var BAR_UPPER = -16 * 10000

# Level Names + Data

var LEVEL_NAMES = ["Prelude", "Introduction", "Commencement", "Elemental", "Protogen", "Inspiration"]
var DIFFICULTIES = ["Easy", "Easy", "Easy", "Normal", "Normal", "Hard"]
var CurrentSelectedLevel = -1

var CheckPointPosition = null
var CheckpointTriggered = false

# Player or proxy enemy death.

# SAVE DATA

var save_path = "user://savegame.save"

func load_data():
	var data = SaveData.new()
	if FileAccess.file_exists(save_path):
		print("FOUND SAVE DATA")
		var file = FileAccess.open(save_path, FileAccess.READ)
		data.levels = file.get_var()
		data.Enemies = file.get_var()
		data.CurrentLevel = file.get_var()
		data.CurrentEnemies = file.get_var()
		
		print("LOADED DATA...", data.levels, " ", data.CurrentLevel)
	else:
		print("ERROR 404 FILE NOT FOUND")
	
	return data
'''
levels = 1
Enemies = []
CurrentLevel = -1
CurrentEnemies = 0
'''
func save_data(data):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data.levels)
	file.store_var(data.Enemies)
	file.store_var(data.CurrentLevel)
	file.store_var(data.CurrentEnemies)

func reset_game():
	save_data(SaveData.new())

# EVERY TICK

var insanity = 0

func _physics_process(delta):
	if (insanity > 0):
		insanity -= 1
		return
	elif (insanity < 0):
		insanity += 1
		return
	load_data()
	insanity = 64
# PROXY

func _process(delta):
	if (PROXY_COOL > 1):
		PROXY_COOL -= 1
		
	# if (PROXY_DIR >= 0):
	# 	print("PROXY DATA ", PROXY_DIR, " ", PROXY_COOL)
		
	if (PROXY_COOL <= 0):
		if Input.is_action_pressed("PROXY_RIGHT"):
			PROXY_DIR = 0
		elif Input.is_action_pressed("PROXY_DOWN"):
			PROXY_DIR = 1
		elif Input.is_action_pressed("PROXY_LEFT"):
			PROXY_DIR = 2
		elif Input.is_action_pressed("PROXY_UP"): 
			PROXY_DIR = 3
		elif Input.is_action_pressed("PROXY_ROT"):
			PROXY_DIR = 4
		else:
			PROXY_DIR = -1
		
	if (PROXY_COOL <= 0 && PROXY_DIR >= 0):
		# print("KEY PRESSED ", PROXY_DIR)
		PROXY_COOL = 4
		PROXY_OVERLAP = 0
		PROXY_IMMOBILE = 0
	elif (PROXY_COOL == 3 && PROXY_DIR >= 0):
		pass
		# print("COLLECTING DATA")
		# print("PROXY OVERLAP ", PROXY_OVERLAP, " | ", PROXY_IMMOBILE)
	elif (PROXY_COOL == 2 && PROXY_DIR >= 0):
		pass
		# print("MOVING PROXY...")
	elif (PROXY_COOL == 1 && PROXY_DIR >= 0):
		PROXY_COOL = 0.5
		if (PROXY_DIR <= 3):
			await get_tree().create_timer(PROXY_CLOCK).timeout
		else:
			await get_tree().create_timer(PROXY_CLOCK * 2).timeout
			
		PROXY_DIR = -1
		PROXY_COOL = 0
	
	# When PROXY_COOL == 3 we collect data from all the PROXY blocks
	# When PROXY_COOL == 2 we move the PROXY blocks when possible.
	# When PROXY_COOL == 1 we simply wait a little bit and then reset.


	
# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	actuator_state = 0
	overlapping = 0
	PLAYER_GRAV = 1
	CETERA_GRAV = 1	
	
	request_ready()

func resetCurrentScene():
	print_debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	actuator_state = 0
	overlapping = 0
	PLAYER_GRAV = 1
	get_tree().reload_current_scene()
	# RESET_SCENE = 2
	

func is_Physical_Entity(v: String):
	if (v == "Player"):
		return 1
	if (v.substr(0, 6) == "Roller"):
		return 1
	if (v.substr(0, 11) == "NormalEnemy"):
		return 1
	if (v.substr(0, 14) == "ProtectedEnemy"):
		return 1
	if (v.substr(0, 16) == "EnemyProtection"):
		return 1
	return 0

func is_Entity(v: String):
	if (is_Physical_Entity(v)):
		return 1
	if (v.substr(0, 12) == "FallingBlock"):
		return 1
	return 0

func is_Block(v: String):
	if (v.substr(0, 7) == "TileMap"):
		return 1
	if (v.substr(0, 7) == "Launcher"):
		return 1
	if (v.substr(0, 6) == "Spring"):
		return 1
	if (v.substr(0, 11) == "PressurePad"):
		return 1
	if (v.substr(0, 8) == "Actuator"):
		return 1
	if (v.substr(0, 7) == "Fragile"):
		return 1
	if (is_Proxy(v)):
		return 1
	return 0

func is_Proxy(v: String):
	if (v.substr(0, 9) == "ProxyCore"):
		return 1
	if (v.substr(0, 10) == "ProxyBlock"):
		return 1

func is_Redstone_Transmission(v: String):
	if (v.substr(0, 12) == "RedstoneWire"):
		return 1
	if (v.substr(0, 12 + 1) == "RedstoneBlock"):
		return 1
	if (v.substr(0, 12 + 1) == "RedstoneDiode"):
		return 1
	if (v.substr(0, 16) == "RedstoneInverter"):
		return 1
	if (v.substr(0, 14) == "PressureSensor"):
		return 1
	if (v.substr(0, 17) == "RedstonePowerable"):
		return 1
	return 0

func redstone_Block_Connected(v: String):
	if (v.substr(0, 12) == "RedstoneWire"):
		return 1
	if (v.substr(0, 12 + 1) == "RedstoneDiode"):
		return 1
	if (v.substr(0, 16) == "RedstoneInverter"):
		return 1
	if (v.substr(0, 16) == "RedstoneActuator"):
		return 1
	return 0

func piston_Movable(v: String):
	if (v.substr(0, 17) == "RedstonePowerable"):
		return 1
	if (v.substr(0, 12) == "MovableBlock"):
		return 1
	if (v.substr(0, 12 + 1) == "RedstoneBlock"):
		return 1
	if (v.substr(0, 5) == "Spike"):
		return 1
	return 0

# MATH / UTIL FUNCTIONS

func sigmoid(x, s): # Sigmoid with dy/dx = s @x = 0
	var res = 1 + exp(-2 * s * x)
	return (2.0 / res) - 1
	
func rotate(disp: Vector2, step):
	if (step == 1):
		return Vector2(-1 * disp.y, disp.x)
	if (step == 2):
		return Vector2(-1 * disp.x, -1 * disp.y)
	if (step == 3):
		return Vector2(disp.y, -1 * disp.x)
	else:
		return Vector2(disp.x, disp.y)
