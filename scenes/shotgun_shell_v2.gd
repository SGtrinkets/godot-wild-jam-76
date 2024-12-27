extends interactable

@onready var shell_pickup_sound: AudioStreamPlayer3D = $shell_pickup_sound
@onready var shell: MeshInstance3D = $ShellLowPolyGreen_003
var pick_up = true


func _on_interacted(_body):
	if pick_up:
		pick_up = false
		GameState.set_value("ammo", GameState.get_value("ammo") + 1)
		shell.hide()
		shell_pickup_sound.play()
		await get_tree().create_timer(0.37).timeout
		queue_free()
