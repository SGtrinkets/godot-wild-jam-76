extends RayCast3D

@onready var interact_ui: Control = $InteractUI
@onready var object_name = $InteractUI/object_name
@onready var bullets: Label = $InteractUI/bullets
@onready var key: TextureRect = $InteractUI/key
@onready var ammo: TextureRect = $InteractUI/ammo



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	object_name.text = ""
	if GameState.get_value("key"):
		key.show()
	else:
		key.hide()
	if GameState.get_value("ammo_found"):
		bullets.text = "0"
		ammo.show()
	else:
		bullets.text = ""
		ammo.hide()
	
	if GameState.get_value("ammo") >0:
		bullets.text = str(GameState.get_value("ammo"))
		if !GameState.get_value("ammo_found"):
			GameState.set_value("ammo_found", true)
	if is_colliding():
		var collider = get_collider()
		if collider is interactable:
			object_name.text = collider.get_prompt()
			if Input.is_action_just_pressed("Interact"):
				collider.interact(owner)
