extends Node


var game_state : String = "Title"
var game_states : Array[String] = ["Title", "Scene Transition", "Paused"]

var scene : int = 0
var scene_list : Array[PackedScene] = [preload("res://scenes/menu/main_menu.tscn")]

var pause_menu : PackedScene = preload("res://scenes/menu/pause_menu.tscn")

# Pausing Stuff
func pause() -> void:
	get_tree().paused = true
	get_tree().current_scene.add_child(pause_menu.instantiate())

func unpause() -> void:
	get_tree().paused = false
	get_tree().current_scene.remove_child(get_tree().current_scene.find_child("Pause Menu"))

# Scene Stuff
func load_scene(new_scene : int = scene+1) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene_list[new_scene])
	scene = new_scene

func get_scene() -> int:
	return scene

# Game State Stuff
func set_game_state(new_state : String) -> void:
	game_state = new_state

func get_game_state() -> String:
	return game_state
