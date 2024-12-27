extends interactable


func _on_interacted(_body):
	GameState.set_value("shotgun", true)
	queue_free()
