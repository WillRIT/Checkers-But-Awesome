extends Node

@export var start_button: Button
@export var quit_button: Button

@export var start_scene: PackedScene

func _ready():
	pass

func change_scene(scene: PackedScene):
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		push_error("Scene is not assigned!")

func _on_start_pressed():
	change_scene(start_scene)

func _on_quit_pressed():
	get_tree().quit()
