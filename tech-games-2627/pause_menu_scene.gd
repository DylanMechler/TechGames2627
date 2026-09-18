extends CanvasLayer

func _ready() -> void:
	hide()
	get_tree().paused = false
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
	get_tree().paused = false
	hide()

func _on_save_button_pressed() -> void:
	print("Save")

func _on_settings_button_pressed() -> void:
	print("Settings")

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	
	if get_tree().current_scene == null:
		get_tree().current_scene = get_parent()
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
