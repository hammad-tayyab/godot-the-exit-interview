extends Control

@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var mute_button: TextureButton = $MuteButton

var is_muted: bool = false

var sound_on_icon: Texture2D = preload("res://images/sound_on (1).png")
var sound_off_icon: Texture2D = preload("res://images/sound_off (1).png")

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_mute_button_pressed() -> void:
	is_muted = !is_muted
	music_player.volume_db = -80 if is_muted else 0
	mute_button.texture_normal = sound_off_icon if is_muted else sound_on_icon
