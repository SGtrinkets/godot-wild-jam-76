extends Node3D

@onready var fog_volume: FogVolume = $FogVolume
@onready var fridge_sound: AudioStreamPlayer3D = $fridge_sound
@onready var pause_menu: Control = $PauseMenu
var paused = false

var height = 1.74

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.set_value("health", 3)
	GameState.set_value("key", 0)
	GameState.set_value("exit", false)
	GameState.set_value("shotgun", false)
	GameState.set_value("ammo", 0)
	GameState.set_value("level", 1)
	GameState.set_value("pause", false)
	fridge_sound.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.get_value("exit"):
		height -= 0.01
		fog_volume.size = Vector3(40.9, height, 27.1)
		fridge_sound.stop()

		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
