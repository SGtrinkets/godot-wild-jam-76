extends interactable

var active := false
@onready var key_insert_sound: AudioStreamPlayer3D = $key_insert_sound

func _ready() -> void:
	$Key.hide()

func _on_interacted(body: Variant) -> void:
	if !active and GameState.get_value("key") > 0:
		active = true
		$Key.show()
		GameState.set_value("key", GameState.get_value("key") - 1)
		GameState.set_value("exit", true)
		enabled = false
		key_insert_sound.play()
