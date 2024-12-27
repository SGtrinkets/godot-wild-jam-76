extends Area3D

@export var time_frozen = 3.0

signal bullet_hit(time_frozen)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func hit():
	emit_signal("bullet_hit", time_frozen)
