extends Control

@export var dialogue_path: String = "res://dialogues/ending_threatened.dialogue"

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon(load(dialogue_path), "ending_start")

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/end_slide.tscn")
