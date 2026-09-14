extends Control

func _ready() -> void:
	DialogueManager.show_dialogue_balloon(load("res://dialogues/intro_scene.dialogue"), "intro_start")
