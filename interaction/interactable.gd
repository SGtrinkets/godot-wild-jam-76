extends CollisionObject3D
class_name interactable

@export var enabled = true
@export var prompt_message = "Interact"


signal interacted(body)

func get_prompt():
	if not enabled:
		return ""
	
	#var key_name := ""
	#for action in InputMap.action_get_events(prompt_input):
	#	if action is InputEventKey:
	#		key_name = action.as_text_physical_keycode()
	#		break
	return prompt_message + "\n[E]"

func interact(body):
	if not enabled:
		return
	
	interacted.emit(body)
