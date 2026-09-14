extends Control

@onready var mute_button: TextureButton = $MuteButton
@onready var gallery_label: Label = $GalleryLabel

var sound_on_icon: Texture2D = preload("res://images/sound_on (1).png")
var sound_off_icon: Texture2D = preload("res://images/sound_off (1).png")

func _ready() -> void:
	if gallery_label:
		gallery_label.text = "Endings discovered: %d / 4" % Global.unlocked_endings.size()

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_pressed() -> void:
	Global.start_new_session()
	get_tree().change_scene_to_file("res://scenes/intro_scene.tscn")

func _on_mute_button_pressed() -> void:
	var game_audio := get_node_or_null("/root/GameAudio") as AudioStreamPlayer
	if game_audio == null:
		return
	game_audio.set("is_muted", not bool(game_audio.get("is_muted")))
	game_audio.volume_db = -80.0 if bool(game_audio.get("is_muted")) else 0.0
	var muted := bool(game_audio.get("is_muted"))
	mute_button.texture_normal = sound_off_icon if muted else sound_on_icon
