extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_restart_button_pressed():
	queue_free() 
	get_tree().change_scene_to_file("res://game_scene.tscn")


func _on_main_menu_button_pressed():
	var main_menu_scene = load("res://main_menu.tscn").instantiate()
	get_tree().root.add_child(main_menu_scene)
	queue_free()
