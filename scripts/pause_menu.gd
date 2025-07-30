extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	visible = false
	
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("pause_blur")
	visible = false
	
func pause():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("pause_blur")
	
	
func test_esc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_btn_pressed() -> void:
	resume()


func _on_restart_btn_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	test_esc()
