class_name ExpeditionTimerLocal extends Control

@onready var timer_label: RichTextLabel = $TimerLabel
@onready var stop_watch_texture: TextureRect = $StopWatchTexture
const COUNTDOWN_BEEP = preload("uid://c6caiqmkt2lt0")
@onready var sfx_player: SFXPlayer = $SfxPlayer

func _ready() -> void:
	PlayerHudSignalBus.show_stop_watch.connect(show_stop_watch)
	PlayerHudSignalBus.load_timer_label.connect(load_timer_label)
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if GameManager.expedition_timer_started:
		update_timer_label()

func update_timer_label() -> void:
	if ExpeditionTimer.seconds <= 10:
		timer_label.text = "[color=red][font_size=46]%s[/font_size][/color]" % [int(ExpeditionTimer.seconds)]
	
		#we'll add play a sfx here and probably any tweens to add effects "pulse" or whatever
	else:
		timer_label.text = "[font_size=46]%s[/font_size]" % [int(ExpeditionTimer.seconds)]

func load_timer_label() -> void:
	timer_label.text = "[font_size=46]%s[/font_size]" % [int(ExpeditionTimer.seconds)]

func show_stop_watch() -> void:
	stop_watch_texture.show()
