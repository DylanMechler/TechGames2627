extends CanvasLayer

func _ready() -> void:
	print("PauseMenuScene _ready() called - Instance ID: ", get_instance_id())
	hide()
	get_tree().paused = false
	# Set to always process in code, so it gets set fresh each time
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		if get_tree().paused:
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()
			$VBoxContainer/ResumeButton.grab_focus()

func _on_resume_button_pressed() -> void:
	print("Resume pressed - Instance: ", get_instance_id())
	get_tree().paused = false
	hide()

func _on_save_button_pressed() -> void:
	print("Save")

func _on_settings_button_pressed() -> void:
	print("Settings")

func _on_main_menu_button_pressed() -> void:
	print("Main menu pressed - Instance: ", get_instance_id())
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
