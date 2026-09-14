extends Control

const DEFAULT_DIALOGUE_PATH := "res://dialogues/interview_room_01.dialogue"
const DEFAULT_TITLE := "interview_start"

func _ready() -> void:
	var global_state := get_node("/root/Global")
	if not global_state.session_started:
		global_state.start_new_session()

	var dialogue_path := DEFAULT_DIALOGUE_PATH
	var title := DEFAULT_TITLE
	if global_state.has_pending_return():
		dialogue_path = global_state._return_dialogue_path
		title = global_state._return_title
		global_state.clear_return()

	var dialogue_resource := load(dialogue_path) as DialogueResource
	if dialogue_resource == null:
		push_error("Could not load dialogue resource: %s" % dialogue_path)
		return
	DialogueManager.show_dialogue_balloon(dialogue_resource, title)
