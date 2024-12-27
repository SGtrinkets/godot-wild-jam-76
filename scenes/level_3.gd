extends Node3D

@onready var fog_volume: FogVolume = $FogVolume
@onready var fridge_sound: AudioStreamPlayer3D = $fridge_sound
@onready var gate: Node3D = $FuncGodotMap/NavigationRegion3D/gate
@onready var gate_2: Node3D = $FuncGodotMap/NavigationRegion3D/gate2
@onready var gate_3: Node3D = $FuncGodotMap/NavigationRegion3D/gate3
var rng = RandomNumberGenerator.new()

var height = 1.74

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.set_value("health", 3)
	GameState.set_value("key", 0)
	GameState.set_value("exit", false)
	GameState.set_value("ammo", GameState.get_value("ammo_final"))
	GameState.set_value("level", 3)
	GameState.set_value("pause", false)
	fridge_sound.play()
	gate.show()
	gate_2.show()
	gate_3.show()
	rng.randomize()
	var i = rng.randi_range(0,2)
	if i == GameState.get_value("door"):
		i = i + 1
	if i == 0:
		gate.queue_free()
	elif i == 1:
		gate_2.queue_free()
	elif i == 2:
		gate_3.queue_free()
	else:
		i = 0
		gate.queue_free()
	
	GameState.set_value("door", i)
	print(i)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.get_value("exit"):
		height -= 0.01
		fog_volume.size = Vector3(40.9, height, 27.1)
		fridge_sound.stop()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameState.set_value("ammo_final", GameState.get_value("ammo"))
		get_tree().change_scene_to_file("res://scenes/level_4.tscn")
