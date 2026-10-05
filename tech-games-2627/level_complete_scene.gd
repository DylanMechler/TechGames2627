extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	
	var game_scene = null
	for child in get_tree().root.get_children():
		if child.name == "GameScene":
			game_scene = child
			break
	
	if game_scene and game_scene.has_method("load_next_level"):
		game_scene.load_next_level()
	else:
		print("ERROR: Could not find GameScene!")
	
	queue_free()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	
	if get_tree().current_scene == null:
		get_tree().current_scene = get_parent()
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
