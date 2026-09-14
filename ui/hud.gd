extends CanvasLayer

# Warning shows one step before the actual loss threshold, so it acts as a warning, not a death notice.
const DANGER_ZONE := 2

@onready var compliance_label: Label = $Margin/HBox/ComplianceLabel
@onready var leverage_label: Label = $Margin/HBox/LeverageLabel
@onready var quit_button: Button = $Margin/HBox/QuitButton
@onready var warning_margin: MarginContainer = $WarningMargin
@onready var warning_label: Label = $WarningMargin/WarningLabel

func _ready() -> void:
	quit_button.pressed.connect(_on_quit_pressed)
	if warning_label:
		warning_label.visible = false
	if warning_margin:
		warning_margin.visible = false

func _process(_delta: float) -> void:
	# Only show this HUD during gameplay scenes, not menus or end screens
	var current_scene := get_tree().current_scene
	var is_gameplay_scene := current_scene != null \
		and current_scene.scene_file_path.begins_with("res://scenes/") \
		and current_scene.scene_file_path != "res://scenes/main_menu.tscn" \
		and current_scene.scene_file_path != "res://scenes/intro_scene.tscn" \
		and current_scene.scene_file_path != "res://scenes/end_slide.tscn"
	$Margin.visible = is_gameplay_scene
	if not is_gameplay_scene:
		if warning_margin:
			warning_margin.visible = false
		return

	compliance_label.text = "Compliance %d" % Global.compliance
	leverage_label.text = "Leverage %d" % Global.leverage
	_update_warning()
	Global.check_for_early_loss()

func _update_warning() -> void:
	var near_loss: bool = Global.compliance <= (Global.LOSE_COMPLIANCE_THRESHOLD + DANGER_ZONE) \
		and Global.leverage <= (Global.LOSE_LEVERAGE_THRESHOLD + DANGER_ZONE)
	var should_show: bool = near_loss and not Global.game_over
	if warning_margin:
		warning_margin.visible = should_show
	if warning_label:
		warning_label.visible = should_show
		if near_loss:
			warning_label.text = "Noman's patience is running out."

func _on_quit_pressed() -> void:
	get_tree().quit()
