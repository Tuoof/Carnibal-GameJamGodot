extends CanvasLayer

var Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_button_up() -> void:
	Level.initializeGame()


func _on_main_menu_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/Main.tscn")
	pass # Replace with function body.
