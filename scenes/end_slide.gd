extends Control

@onready var title_label: Label = $Margin/VBox/TitleLabel
@onready var ending_name_label: Label = $Margin/VBox/EndingNameLabel
@onready var blurb_label: Label = $Margin/VBox/BlurbLabel
@onready var gallery_label: Label = $Margin/VBox/GalleryLabel
@onready var play_again_button: Button = $Margin/VBox/HBox/PlayAgainButton
@onready var quit_button: Button = $Margin/VBox/HBox/QuitButton

const ENDING_INFO := {
	"leveraged": {
		"name": "LEVERAGED",
		"blurb": "You outplayed Gunman Corp. You got more than they wanted to give — money, protection, proof you can use later. Whether that makes you smart or just as bad as them is a question the game leaves with you."
	},
	"bought": {
		"name": "BOUGHT",
		"blurb": "You took the deal. Clean, quiet, complicit. You'll never have to think about Gunman Corp again — you'll just have to live with everything you didn't have to think about to get here."
	},
	"threatened": {
		"name": "THREATENED",
		"blurb": "You left with nothing. No money, no leverage, no illusions. Just the quiet certainty that you're being watched, and the knowledge that you never really had a choice at all."
	},
	"buried": {
		"name": "BURIED",
		"blurb": "You pushed too hard, too visibly, with nothing to back it up. Gunman Corp decided you weren't worth the risk of leaving alive to talk. The door didn't feel like an exit."
	},
}

func _ready() -> void:
	var info: Dictionary = ENDING_INFO.get(Global.last_ending, {"name": "THE END", "blurb": ""})
	title_label.text = "THE EXIT INTERVIEW"
	ending_name_label.text = "Ending: %s" % info["name"]
	blurb_label.text = info["blurb"]
	gallery_label.text = "Endings discovered: %d / 4" % Global.unlocked_endings.size()
	play_again_button.pressed.connect(_on_play_again_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_again_pressed() -> void:
	Global.reset_game()

func _on_quit_pressed() -> void:
	get_tree().quit()
