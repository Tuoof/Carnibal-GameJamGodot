extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI_Canvas.show()
	$BGM.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_button_up() -> void:
	$UI_Canvas.hide()
	$VideoStreamPlayer.play()
	$BGM.stop()
	pass # Replace with function body.


func _on_quit_button_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Scene/Level.tscn")
	pass # Replace with function body.
