extends AudioStreamPlayer

# Persistent ambient score. Survives scene changes as an Autoload node.
var is_muted := false
var ambient_track: AudioStream = preload("res://audio/universfield-tense-atmosphere-129627.mp3")

func _ready() -> void:
	stream = ambient_track
	finished.connect(play)
	play()

func toggle_mute() -> void:
	is_muted = !is_muted
	volume_db = -80.0 if is_muted else 0.0
