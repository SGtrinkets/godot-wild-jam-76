extends Node3D

const SPEED = 40.0

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var timer: Timer = $Timer
@onready var freeze: AudioStreamPlayer3D = $freeze


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -SPEED) * delta 
	mesh_instance_3d.visible = false
	
	if ray_cast_3d.is_colliding():
		gpu_particles_3d.emitting = true
		ray_cast_3d.enabled = false
		if ray_cast_3d.get_collider().is_in_group("enemy"):
			ray_cast_3d.get_collider().hit()
			queue_free()
		


func _on_timer_timeout() -> void:
	queue_free()
