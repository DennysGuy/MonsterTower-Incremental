class_name AudioSettingsMenu  extends Panel

@onready var master_volume_slider: HSlider = $MasterVolumeSlider
@onready var music_volume_slider: HSlider = $MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $SFXVolumeSlider
@onready var ambience_volume_slider: HSlider = $AmbienceVolumeSlider
@onready var check_box: CheckBox = $CheckBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume_slider.value = SettingsManager.get_audios_setting("Master")
	music_volume_slider.value = SettingsManager.get_audios_setting("Music")
	sfx_volume_slider.value = SettingsManager.get_audios_setting("SFX")
	ambience_volume_slider.value = SettingsManager.get_audios_setting("Ambience")
	check_box.button_pressed = GameManager.monster_voices_toggled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.save_audio_setting("Master",value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	SettingsManager.save_audio_setting("Music",value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	SettingsManager.save_audio_setting("SFX", value)

func _on_ambience_volume_slider_value_changed(value: float) -> void:
	SettingsManager.save_audio_setting("Ambience", value)


func _on_button_button_up() -> void:
	self.hide()


func _on_check_box_toggled(toggled_on: bool) -> void:
	SaveManager.save_various_settings("Monster Voices Toggled", toggled_on)
	GameManager.monster_voices_toggled = SaveManager.load_various_settings("Monster Voices Toggled")
