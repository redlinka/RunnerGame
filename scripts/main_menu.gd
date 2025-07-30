extends Control
@onready var game_scene = preload("res://scenes/Game.tscn")


func _on_start_btn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_btn_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()
