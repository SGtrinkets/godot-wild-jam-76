extends Node3D


@onready var camera = $camera_sound
@onready var animation_player = $Transition
@onready var color_rect = $Transition/ColorRect
@onready var fade_timer = $fade_timer
@onready var main_menu = $main_menu
@onready var option_menu: VBoxContainer = $option_menu
@onready var audio_menu: VBoxContainer = $audio_menu
@onready var control_menu: Control = $control_menu
@onready var title: TextureRect = $title


var position_speed = 0.5
const first_level = preload("res://scenes/opening_scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.show()
	option_menu.hide()
	audio_menu.hide()
	control_menu.hide()
	main_menu.show()
	GameState.set_value("pause", false)
	Engine.time_scale = 1
	animation_player.play("fade_in")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position.z -= position_speed * delta


func _on_start_pressed() -> void:
	animation_player.play("fade_out")
	fade_timer.start()


func _on_options_pressed() -> void:
	main_menu.hide()
	title.hide()
	option_menu.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_packed(first_level)


func _on_video_pressed() -> void:
	option_menu.hide()


func _on_audio_pressed() -> void:
	option_menu.hide()
	audio_menu.show()


func _on_controls_pressed() -> void:
	option_menu.hide()
	control_menu.show()


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_back_options_pressed() -> void:
	option_menu.show()
	audio_menu.hide()
	control_menu.hide()


func _on_back_to_menu_pressed() -> void:
	option_menu.hide()
	main_menu.show()
	title.show()
