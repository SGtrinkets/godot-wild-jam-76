extends interactable

func _physics_process(delta: float) -> void:
	if GameState.get_value("exit") == true:
		queue_free()
