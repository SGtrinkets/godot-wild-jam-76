extends CharacterBody3D

@onready var head = $head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var up_collision_detection: RayCast3D = $up_collision_detection
@onready var footstep_audio = $footstep
@onready var footstep_timer = $footstep_timer

@export var sprint_speed = 5.0
@export var speed = 3.5
@export var crouch_speed = 1.0
@export var jump_height = 4.5


@export var mouse_sensitivity = 0.4

@export var interact_distance : float = 3.0
@onready var interaction_area = $InteractionArea 
@onready var shotgun: StaticBody3D = $head/Camera3D/shotgun
@onready var shotgun_animation: AnimationPlayer = $head/Camera3D/shotgun/AnimationPlayer
@onready var shotgun_barrel: RayCast3D = $head/Camera3D/shotgun/RayCast3D
@onready var sound_enabled_timer: Timer = $sound_enabled_timer
@onready var damage_sound_effect: AudioStreamPlayer3D = $damage_sound_effect
@onready var health_bar: ProgressBar = $head/Camera3D/health_bar
@onready var bullets: Label = $head/Camera3D/interact/RayCast3D/InteractUI/bullets



var isMoving = true
var lerp_speed = 10.0
var direction = Vector3.ZERO
var crouch = false
var shotgun_equipped = false

@export var crouching_depth = -1.125


var bullet = load("res://scenes/bullet.tscn")
var instance



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pauseMenu()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !GameState.get_value("pause"):
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _play_footstep_audio():
	if footstep_audio and !footstep_audio.playing:
		footstep_audio.pitch_scale = randf_range(0.8, 1.2)
		footstep_audio.play()
		footstep_timer.start()
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	health_bar.value = GameState.get_value("health")
	
	
	if GameState.get_value("health") == 0:
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	
	if GameState.get_value("attack"):
		damage_sound_effect.play()
		GameState.set_value("attack", false)
	
	#GameState.set_value("sound", false)
	if isMoving:
		if Input.is_action_pressed("Crouch"):
			crouch = true
			speed = crouch_speed
			if GameState.get_value("shotgun") and shotgun_equipped:
				shotgun_animation.play("put_away")
				shotgun_equipped = false
			head.position.y = lerp(head.position.y, 0.525 + crouching_depth, delta * lerp_speed)
			standing_collision_shape.disabled = true
			crouching_collision_shape.disabled = false
		elif(!up_collision_detection.is_colliding()):
			crouch = false
			crouching_collision_shape.disabled = true
			standing_collision_shape.disabled = false
			head.position.y = lerp(head.position.y, 0.525, delta * lerp_speed)
			if Input.is_action_pressed("Sprint"):
				speed = 3.5
			else:
				speed = 3.5
		
		if not is_on_floor():
			velocity += get_gravity() * delta

		if GameState.get_value("attack"):
			GameState.set_value("health", GameState.get_value("health")-1)
		# Handle jump.

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
		if GameState.get_value("shotgun") and !shotgun_equipped and !crouch:
			if !shotgun_animation.is_playing():
				shotgun_animation.play("aim")
				shotgun_equipped = true
		
		if Input.is_action_pressed("Shoot") and !GameState.get_value("pause"):
			if !shotgun_animation.is_playing() and !crouch and shotgun_equipped and GameState.get_value("ammo")>0:
				shotgun_animation.play("shoot")
				instance = bullet.instantiate()
				instance.position = shotgun_barrel.global_position
				instance.transform.basis = shotgun_barrel.global_transform.basis
				get_parent().add_child(instance)
				if shotgun_barrel.is_colliding():
					var target = shotgun_barrel.get_collider()
					if target.is_in_group("enemy"):
						pass
				GameState.set_value("ammo", GameState.get_value("ammo")-1)
		
	
	move_and_slide()


func _on_footstep_timer_timeout() -> void:
	if velocity.length() > 0.1 and is_on_floor() and speed == 3.5 and isMoving:
		_play_footstep_audio()
		GameState.set_value("sound", true)
		sound_enabled_timer.start()
	else:
		GameState.set_value("sound", false)
		
	


func _on_sound_enabled_timer_timeout() -> void:
	GameState.set_value("sound", false)
