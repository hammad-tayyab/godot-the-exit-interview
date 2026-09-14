extends Node

# --- Constants ---
const SAVE_PATH := "user://exit_interview_save.json"
const LOSE_COMPLIANCE_THRESHOLD := -3
const LOSE_LEVERAGE_THRESHOLD := -3

# --- Meters ---
var compliance := 0
var leverage := 0

# --- Flashback Return Tracking ---
var _return_dialogue_path := ""
var _return_title := ""

# --- Session & Ending State ---
var session_started := false
var game_over := false
var last_ending := ""
var unlocked_endings: Array[String] = []

# --- Specific Choice Tracking ---
# Captures past decisions for dialogue callbacks and gambles
var marcus_path := ""       # "told" | "pressured" | "bought"
var priya_path := ""        # "deflected" | "warned" | "escalated"
var volkov_path := ""       # "held_line" | "compromise" | "considered"
var reckoning_choice := ""  # "copied" | "cleaned" | "walked"
var escalation_backfired := false


# --- Built-in Callbacks ---

func _ready() -> void:
	_load_unlocked_endings()


# --- Session Management ---

func start_new_session() -> void:
	compliance = 0
	leverage = 0
	session_started = true
	game_over = false
	last_ending = ""
	marcus_path = ""
	priya_path = ""
	volkov_path = ""
	reckoning_choice = ""
	escalation_backfired = false
	clear_return()

func reset_game() -> void:
	compliance = 0
	leverage = 0
	game_over = false
	last_ending = ""
	session_started = false
	marcus_path = ""
	priya_path = ""
	volkov_path = ""
	reckoning_choice = ""
	escalation_backfired = false
	# unlocked_endings persists across playthroughs
	clear_return()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")

func begin_interview() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/interview_room.tscn")


# --- Flashback Flow ---

func trigger_flashback(flashback_id: int, return_dialogue_path: String, return_title: String) -> void:
	_return_dialogue_path = return_dialogue_path
	_return_title = return_title
	var flashback_path := "res://scenes/flashback_%02d.tscn" % flashback_id
	get_tree().call_deferred("change_scene_to_file", flashback_path)

func return_from_flashback() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/interview_room.tscn")

func clear_return() -> void:
	_return_dialogue_path = ""
	_return_title = ""

func has_pending_return() -> bool:
	return _return_title != ""


# --- Gamble Mechanics ---

func roll_escalation_gamble() -> void:
	escalation_backfired = (randf() < 0.4)


# --- Win / Loss & Ending Evaluation ---

func check_for_early_loss() -> void:
	if game_over:
		return
	if compliance <= LOSE_COMPLIANCE_THRESHOLD and leverage <= LOSE_LEVERAGE_THRESHOLD:
		go_to_ending("buried")

func evaluate_final_ending() -> void:
	if game_over:
		return
	if leverage >= 4:
		go_to_ending("leveraged")
	elif compliance >= 3:
		go_to_ending("bought")
	elif compliance <= -3 or leverage <= -3:
		go_to_ending("buried")
	else:
		go_to_ending("threatened")

func go_to_ending(ending_id: String) -> void:
	if game_over:
		return
	game_over = true
	last_ending = ending_id
	if not unlocked_endings.has(ending_id):
		unlocked_endings.append(ending_id)
		_save_unlocked_endings()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ending_%s.tscn" % ending_id)


# --- Persistence ---

func _load_unlocked_endings() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(data) == TYPE_DICTIONARY and data.has("unlocked_endings"):
		unlocked_endings.assign(data["unlocked_endings"])

func _save_unlocked_endings() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({"unlocked_endings": unlocked_endings}))
	file.close()
