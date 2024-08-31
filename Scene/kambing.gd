extends Area2D

var AUTO_SPEED = 2.5
var Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level = get_parent()
	AUTO_SPEED += Level.final_score/10
	print("generate kambing with auto speed: ", AUTO_SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	autoMove()
	
func autoMove():
	if Level.game_running:
		position.x -= AUTO_SPEED


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
