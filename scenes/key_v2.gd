extends interactable

@onready var pick_up_audio: AudioStreamPlayer3D = $pick_up
@onready var key: MeshInstance3D = $Key
var pick_up = true

func _on_interacted(_body):
	if pick_up:
		pick_up = false
		GameState.set_value("key", GameState.get_value("key") + 1)
		key.hide()
		pick_up_audio.play()
		await get_tree().create_timer(0.5).timeout
		queue_free()
