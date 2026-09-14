extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	queue_free() 
	get_tree().change_scene_to_file("res://game_scene.tscn")


func _on_main_menu_button_pressed() -> void:
	var main_menu_scene = load("res://main_menu.tscn").instantiate()
	get_tree().root.add_child(main_menu_scene)
	queue_free()
