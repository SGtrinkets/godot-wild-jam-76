extends CharacterBody3D

var player = null

var level_3_patrol_points = PackedVector3Array([Vector3(10.614, 0.57, -5.97), Vector3(10.614, 0.57, 5.7)])


@export var player_path : NodePath
var isChasing = false
var chase_sound_played = false
var reachesPoint = false
var hasPoint = true
var isFrozen = true
var state_machine
var randomPos
var lastPos
var player_in_sound = false
var waiting_for_animation = false
var isMoving = false
var player_in_body = false
var hit_by_bullet = false
@export var hit_player = false
@export var player_in_attack_range = false

@onready var sound_detection_region: Area3D = $sound_detection_region

@export var reset_speed = 0
@export var SPEED = 20.0
var normal_speed = 20.0
@export var attack_range = 2.0
@export var delta_multiplier = 15
@onready var alien_enemy: CharacterBody3D = $"."

@onready var navigation_agent = $NavigationAgent3D
@onready var anim: AnimationPlayer = $AnimationPlayer
#@onready var animation_tree = $AnimationTree
@onready var chase_timer = $chase_timer
@onready var detection_notifier: CSGTorus3D = $sound_detection_region/detection_notifier
@onready var idle_sound: AudioStreamPlayer3D = $idle_sound
@onready var chase_sound: AudioStreamPlayer3D = $chase_sound
@onready var ticking_sound: AudioStreamPlayer3D = $ticking_sound


var sound_detected = false

var i = 1

func _ready() -> void:
	player = get_node(player_path)
	isFrozen = true


func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	
	if player_in_body and GameState.get_value("sound"):
		isChasing = true
		
	if player_in_attack_range and hit_player:
		GameState.set_value("health", GameState.get_value("health")-1)
		hit_player = false
		print("hit confirmed! Health is now ",  GameState.get_value("health"))
	
	if isFrozen:
		anim.play("frozen")
		detection_notifier.hide()
		SPEED = reset_speed
	else:
		SPEED = normal_speed
		if isChasing:
			chase()
			if !chase_sound.playing:
				idle_sound.stop()
				if !chase_sound_played:
					chase_sound.play()
					chase_sound_played = true
				else:
					pass
			if _target_in_range():
				anim.play("attack")
			else:
				anim.play("run")
		else:
			if !idle_sound.playing:
				chase_sound.stop()
				idle_sound.play()
				chase_sound_played = false
			detection_notifier.show()
			wandering()
			if reachesPoint:
				anim.play("idle")
			else:
				anim.play("walk")


	
	var direction = navigation_agent.get_next_path_position()-global_position
	direction = direction.normalized()
	if !isChasing:
		velocity = velocity.lerp(direction*SPEED, delta *delta_multiplier)
	else:
		velocity = velocity.lerp(direction*SPEED*1.5, delta *delta_multiplier)
		alien_enemy.rotation.x = 0.0
	
	if !GameState.get_value("exit") or hit_by_bullet:
		isFrozen = true
	else:
		isFrozen = false
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < attack_range

func chase():
	look_at(player.position)
	navigation_agent.target_position = player.global_position

func wandering():
	# Looping through patrol points
	
	if reachesPoint:  # Prevent wandering logic if already moving to a point
		return
		
	if i == 2:
		i = 0
	
	# Set the next patrol point
	var target_point = level_3_patrol_points[i]
	target_point.y = global_position.y
	look_at(target_point)
	navigation_agent.target_position = target_point

	# Calculate distance to the target point
	#var distance = global_position.distance_to(target_point)

	# Check if the character has reached the patrol point
	if global_position.distance_to(target_point) < 0.1:
		# Stop moving and switch to idle animation
		reachesPoint = true
		if not waiting_for_animation:
			_play_patrol_animation()
		
	
func _play_patrol_animation():
	# Play an animation from the animation tree
	#state_machine.travel("idle")  # Replace "Idle" with your desired animation name
	anim.play("idle")
	# Wait for the animation to complete
	await get_tree().create_timer(7.4333).timeout  # Adjust duration based on animation length
	
	# Go to the next patrol point after animation completes
	i = (i + 1) % level_3_patrol_points.size()
	
	var next_point = level_3_patrol_points[i]
	next_point.y = global_position.y
	navigation_agent.target_position = next_point
	
	anim.play("walk")
	waiting_for_animation = false
	reachesPoint = false

func _on_sound_detection_region_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !isFrozen:
		player_in_body = true
	


func _on_sound_detection_region_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_body = false
		if isChasing:
			chase_timer.start()
	
	
	


func _on_chase_timer_timeout() -> void:
	isChasing = false
	


func _on_hit_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("bullet"):
		print("hit confirmed!")
		isFrozen = true
		await get_tree().create_timer(5.0).timeout
	if body.is_in_group("player"):
		isChasing = true


func _on_hit_area_bullet_hit(time_frozen: Variant) -> void:
	isFrozen = true
	hit_by_bullet = true
	ticking_sound.play()
	await get_tree().create_timer(time_frozen).timeout
	ticking_sound.stop()
	hit_by_bullet = false
	isFrozen = false


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and isChasing and !isFrozen:
		print("In")
		player_in_attack_range = true
		
func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and player_in_attack_range:
		player_in_attack_range = false
		print("Out")


func _on_feet_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and !isChasing and !isFrozen:
		isChasing = true
