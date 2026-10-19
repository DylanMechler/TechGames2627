extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	print("Randomizing buttons!")
	var upgrade_list = get_children()
	for i in range(3):
		var random_option = randi() % upgrade_list.size()
		var option = upgrade_list.pop_at(random_option)
		
	for i in upgrade_list:
		i.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
