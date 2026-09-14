extends Control

const DEFAULT_DIALOGUE_PATH := "res://dialogues/interview_room_01.dialogue"
const DEFAULT_TITLE := "interview_start"

func _ready() -> void:
	if not Global.session_started:
		Global.start_new_session()

	var dialogue_path := DEFAULT_DIALOGUE_PATH
	var title := DEFAULT_TITLE

	# Resume from a flashback return point if one exists
	if Global.has_pending_return():
		dialogue_path = Global._return_dialogue_path
		title = Global._return_title
		Global.clear_return()

	var dialogue_resource := load(dialogue_path) as DialogueResource
	if dialogue_resource == null:
		push_error("Could not load dialogue resource: %s" % dialogue_path)
		return
	DialogueManager.show_dialogue_balloon(dialogue_resource, title)
