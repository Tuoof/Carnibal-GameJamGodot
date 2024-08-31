extends Node2D

var record
var peakVolume : float

var score : int
var final_score : int
var score_modifier : int = 100

var screen_size : Vector2i
var ground_height : int
var game_running : bool

var kambing_node = preload("res://Scene/Kambing.tscn")
var mobil_node = preload("res://Scene/mobil.tscn")
var obstacle_types := [kambing_node, mobil_node]
var obstacles : Array
var last_obstacles

const CLOWN_START_POS := Vector2i(300,485)
const CAM_START_POS := Vector2i(576, 324)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeGame()
	initializeMic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		detectMicInput()
		generateObstacles()
		showScore()
		movingObject()
	
	#if peakVolume > -10:
	#print(abs(peakVolume))

func initializeGame():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	
	score = 0
	showScore()
	game_running = true
	get_tree().paused = false
	
	#delete all obstacles
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	$Clown.position = CLOWN_START_POS
	$Clown.velocity = Vector2i.ZERO
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i.ZERO
	
	$GameOver.hide()

func initializeMic():
	record = AudioServer.get_bus_index("Record")
	
func detectMicInput():
	game_running = true
	peakVolume = AudioServer.get_bus_peak_volume_left_db(record, 0)
	$Clown.jump_sound(peakVolume)
	
func movingObject():
	$Clown.autoMove()
	$Camera2D.autoMove()
	
	score += $Clown.AUTO_SPEED
	
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
		
	for obs in obstacles:
		if obs.position.x < ($Camera2D.position.x - (screen_size.x) ):
			removeObstacle(obs)

func showScore():
	final_score = score / score_modifier
	$HUD/ScoreLabel.text = "SCORE: " + str(final_score)
	
func generateObstacles():
	var rand_obs_spawn = randi_range(1,3)
	
	if obstacles.is_empty() or last_obstacles.position.x < randi_range(300, 500):
		for i in rand_obs_spawn:
			var randomed_obstacle = obstacle_types[ randi() % obstacle_types.size() ]
			var obstacle_choosed = randomed_obstacle.instantiate()
			add_child(obstacle_choosed)
			move_child(obstacle_choosed, 2)
			
			var obstacle_height = obstacle_choosed.get_node("CollisionShape2D").get_shape().get_size().y
			var obstacle_scale = obstacle_choosed.get_node("CollisionShape2D").scale
			var obstacle_x = $Camera2D.position.x + (screen_size.x/2) + randi_range(150*i, 200*i+1)
			var obstacle_y = screen_size.y - ground_height - (obstacle_height * obstacle_scale.y/2) +100
			
			last_obstacles = obstacle_choosed
			addObstacle(obstacle_choosed, obstacle_x, obstacle_y)

func addObstacle(obstacle, x, y):
	obstacle.position = Vector2i(x, y)
	obstacle.body_entered.connect(hit_obs)
	add_child(obstacle)
	obstacles.append(obstacle)

func removeObstacle(obstacle):
	obstacle.queue_free()
	obstacles.erase(obstacle)

func hit_obs(body):
	if body.name == "Clown":
		game_over()
		print("collision")

func game_over():
	#get_tree().paused = true
	game_running = false
	$Clown.gameOver()
	$GameOver.show()
