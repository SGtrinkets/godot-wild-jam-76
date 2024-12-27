extends Control

@onready var pause_menu: Control = $"."
@onready var pause: VBoxContainer = $MarginContainer/pause
@onready var option_menu: VBoxContainer = $MarginContainer/option_menu
@onready var audio_menu: VBoxContainer = $MarginContainer/audio_menu
@onready var control_menu: Control = $MarginContainer/control_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	pause.hide()
	Engine.time_scale = 1
	option_menu.hide()
	audio_menu.hide()
	control_menu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("Pause"):
		#pauseMenu()

func pauseMenu():
	if GameState.get_value("pause"):
		pause_menu.hide()
		pause.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_menu.show()
		pause.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	var paused = GameState.get_value("pause")
	paused = !paused
	
	GameState.set_value("pause", paused)


func _on_resume_pressed() -> void:
	pause_menu.hide()
	pause.hide()
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _on_options_pressed() -> void:
	pause.hide()
	option_menu.show()


func _on_retry_current_level_pressed() -> void:
	if GameState.get_value("level") == 1:
		get_tree().change_scene_to_file("res://scenes/opening_scene.tscn")
	if GameState.get_value("level") == 2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	if GameState.get_value("level") == 3:
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	if GameState.get_value("level") == 4:
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_audio_pressed() -> void:
	audio_menu.show()
	option_menu.hide()


func _on_controls_pressed() -> void:
	control_menu.show()
	option_menu.hide()


func _on_back_to_pause_menu_pressed() -> void:
	option_menu.hide()
	pause.show()
	


func _on_back_to_options_pressed() -> void:
	control_menu.hide()
	audio_menu.hide()
	option_menu.show()
