extends Control

const FLASHBACK_DIALOGUE := preload("res://dialogues/flashback_02.dialogue")

func _ready() -> void:
	DialogueManager.show_dialogue_balloon(FLASHBACK_DIALOGUE, "flashback_start")
