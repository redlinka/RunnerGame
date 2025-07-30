extends Control
var game_scene_path : String = "res://scenes/Game.tscn"

func _on_retry_btn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	get_tree().change_scene_to_file(game_scene_path)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
