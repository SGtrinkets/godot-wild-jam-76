extends Node

var state := {
	"health": 3,
	"key": 0,
	"exit": false,
	"sound": false,
	"shotgun": false,
	"ammo": 0,
	"ammo_found": false,
	"ammo_final": 0, 
	"attack" : false,
	"level" : 1,
	"door" : 0,
	"pause": false
}

func has_value(key):
	return state.has(key)


func get_value(key):
	if state.has(key):
		return state[key]
	
	printerr("Key not present in state: ", key)


func set_value(key, value):
	state[key] = value
