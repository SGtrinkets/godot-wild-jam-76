extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_pressed() -> void:
	if GameState.get_value("level") == 1:
		get_tree().change_scene_to_file("res://scenes/opening_scene.tscn")
	if GameState.get_value("level") == 2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	if GameState.get_value("level") == 3:
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	if GameState.get_value("level") == 4:
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
