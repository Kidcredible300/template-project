extends Node

var master_vol : float = 1
var music_vol : float = 1
var sound_vol : float = 1


func get_volume(channel : String) -> float:
	if channel == "Music":
		return music_vol
	elif channel == "Sound":
		return sound_vol
	else:
		return master_vol


func set_volume(channel : String, vol : float) -> void:
	if channel == "Music":
		music_vol = vol
	elif channel == "Sound":
		sound_vol = vol
	else:
		master_vol = vol
